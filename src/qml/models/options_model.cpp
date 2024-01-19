// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <qml/models/options_model.h>

#include <common/args.h>
#include <common/settings.h>
#include <common/system.h>
#include <interfaces/node.h>
#include <logging.h>
#include <node/utxo_snapshot.h>
#include <qt/guiconstants.h>
#include <qt/optionsmodel.h>
#include <txdb.h>
#include <univalue.h>
#include <util/fs.h>
#include <util/fs_helpers.h>
#include <validation.h>

#include <cassert>

OptionsQmlModel::OptionsQmlModel(interfaces::Node& node)
    : m_node{node}
{
    m_dbcache_size_mib = SettingToInt(m_node.getPersistentSetting("dbcache"), nDefaultDbCache);

    int64_t prune_value{SettingToInt(m_node.getPersistentSetting("prune"), 0)};
    m_prune = (prune_value > 1);
    m_prune_size_gb = m_prune ? PruneMiBtoGB(prune_value) : DEFAULT_PRUNE_TARGET_GB;

    m_script_threads = SettingToInt(m_node.getPersistentSetting("par"), DEFAULT_SCRIPTCHECK_THREADS);
}

void OptionsQmlModel::setDbcacheSizeMiB(int new_dbcache_size_mib)
{
    if (new_dbcache_size_mib != m_dbcache_size_mib) {
        m_dbcache_size_mib = new_dbcache_size_mib;
        m_node.updateRwSetting("dbcache", new_dbcache_size_mib);
        Q_EMIT dbcacheSizeMiBChanged(new_dbcache_size_mib);
    }
}

void OptionsQmlModel::setListen(bool new_listen)
{
    if (new_listen != m_listen) {
        m_listen = new_listen;
        m_node.updateRwSetting("listen", new_listen);
        Q_EMIT listenChanged(new_listen);
    }
}

void OptionsQmlModel::setNatpmp(bool new_natpmp)
{
    if (new_natpmp != m_natpmp) {
        m_natpmp = new_natpmp;
        m_node.updateRwSetting("natpmp", new_natpmp);
        Q_EMIT natpmpChanged(new_natpmp);
    }
}

void OptionsQmlModel::setPrune(bool new_prune)
{
    if (new_prune != m_prune) {
        m_prune = new_prune;
        m_node.updateRwSetting("prune", pruneSetting());
        Q_EMIT pruneChanged(new_prune);
    }
}

void OptionsQmlModel::setPruneSizeGB(int new_prune_size_gb)
{
    if (new_prune_size_gb != m_prune_size_gb) {
        m_prune_size_gb = new_prune_size_gb;
        m_node.updateRwSetting("prune", pruneSetting());
        Q_EMIT pruneSizeGBChanged(new_prune_size_gb);
    }
}

void OptionsQmlModel::setScriptThreads(int new_script_threads)
{
    if (new_script_threads != m_script_threads) {
        m_script_threads = new_script_threads;
        m_node.updateRwSetting("par", new_script_threads);
        Q_EMIT scriptThreadsChanged(new_script_threads);
    }
}

void OptionsQmlModel::setServer(bool new_server)
{
    if (new_server != m_server) {
        m_server = new_server;
        m_node.updateRwSetting("server", new_server);
        Q_EMIT serverChanged(new_server);
    }
}

void OptionsQmlModel::setUpnp(bool new_upnp)
{
    if (new_upnp != m_upnp) {
        m_upnp = new_upnp;
        m_node.updateRwSetting("upnp", new_upnp);
        Q_EMIT upnpChanged(new_upnp);
    }
}

common::SettingsValue OptionsQmlModel::pruneSetting() const
{
    assert(!m_prune || m_prune_size_gb >= 1);
    return m_prune ? PruneGBtoMiB(m_prune_size_gb) : 0;
}

QString PathToQString(const fs::path &path)
{
    return QString::fromStdString(path.u8string());
}

QString OptionsQmlModel::getDefaultDataDirectory()
{
    return PathToQString(GetDefaultDataDir());
}

void OptionsQmlModel::setDefaultSnapshotDirectory(QString path)
{
    // QString path = getDefaultDataDirectory();
    if (!path.isEmpty()) {
        UniValue pathValue(path.toStdString());
        m_node.updateRwSetting("snapshotdir", pathValue);
        Q_EMIT snapshotDirectoryChanged();
    }
}

bool OptionsQmlModel::getLoadUtxo()
{
    UniValue loadUtxoValue = m_node.getSetting("loadutxo");
    if (loadUtxoValue.isNull()) {
        return false;
    }
    bool loadUtxo = loadUtxoValue.get_bool();
    LogPrintf("[options_model] loadUtxo = %s\n", loadUtxo ? "true" : "false"); // for debug only. delete later
    return loadUtxo;
}


void OptionsQmlModel::setLoadUtxo(bool new_load_utxo)
{
    if (new_load_utxo != m_load_utxo) {
        m_load_utxo = new_load_utxo;
        m_node.updateRwSetting("loadutxo", new_load_utxo);
        Q_EMIT loadUtxoChanged(new_load_utxo);
    }
}

QString OptionsQmlModel::getSnapshotDirectory()
{
    UniValue snapshotDirValue = m_node.getPersistentSetting("snapshotdir");
    if (snapshotDirValue.isNull()) {
        return "";
    }
    std::string snapshotDir = snapshotDirValue.get_str();
    // for debug only. delete later
    LogPrintf("[options_model] snapshotDir = %s\n", snapshotDir);
    return QString::fromStdString(snapshotDir);
}

bool OptionsQmlModel::getSnapshotLoaded()
{
    UniValue snapshotLoadedValue = m_node.getSetting("snapshotloaded");
    if (snapshotLoadedValue.isNull()) {
        return false;
    }
    bool snapshotLoaded = snapshotLoadedValue.get_bool();
    LogPrintf("[options_model] snapshotLoaded = %s\n", snapshotLoaded ? "true" : "false"); // for debug only. delete later
    return snapshotLoaded;
}

void OptionsQmlModel::setSnapshotLoaded(bool new_snapshot_loaded)
{
    if (new_snapshot_loaded != m_snapshot_loaded) {
        m_snapshot_loaded = new_snapshot_loaded;
        m_node.updateRwSetting("snapshotloaded", new_snapshot_loaded); // for debug only. delete later
        Q_EMIT snapshotLoadedChanged(new_snapshot_loaded);
    }
}