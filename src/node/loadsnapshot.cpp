// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.


// #include <node/loadsnapshot.h>

#include <logging.h>
#include <node/blockstorage.h>
#include <node/context.h>
#include <node/utxo_snapshot.h>
#include <streams.h>
#include <validation.h>

#include <util/fs.h>

#include <util/any.h>
#include <string>


using node::BlockManager;
using node::NodeContext;
using node::SnapshotMetadata;

struct CUpdatedBlock
{
    uint256 hash;
    int height;
};

// using namespace node;

bool ChainstateManager::LoadSnapshot(NodeContext& node)
{
    std::string username = getenv("USER");

    std::string path_string = "/home/" + username + "/qml-au-signet/signet/utxo-signet-160000.dat";

    // NodeContext node;

    fs::path path(fs::u8path(path_string));
    if (!fs::exists(path)) {
        LogPrintf("[loadsnapshot] snapshot file %s does not exist\n", path.u8string());
        return false;
    }

    FILE* file{fsbridge::fopen(path, "rb")};

    AutoFile afile{file};
    if (afile.IsNull()) {
        LogPrintf("[loadsnapshot] failed to open snapshot file %s\n", path_string);
        return false;
    }

    // Read the snapshot metadata.
    SnapshotMetadata metadata;
    afile >> metadata;

    // Get the base blockhash and look up the corresponding CBlockIndex object.
    uint256 base_blockhash = metadata.m_base_blockhash;
    int max_secs_to_wait_for_headers = 60 * 10;
    CBlockIndex* snapshot_start_block = nullptr;

    LogPrintf("[loadsnapshot] waiting to see blockheader %s in headers chain before snapshot activation\n",
        base_blockhash.ToString());
    
    if (node.chainman == nullptr) {
    // Handle error
    LogPrintf("[loadsnapshot] node.chainman is null\n");
    return false;
    }

    ChainstateManager& chainman = *node.chainman;

    // snapshot_start_block = chainman.m_blockman.LookupBlockIndex(base_blockhash);

    // if (!snapshot_start_block) {
    //     LogPrintf("[loadsnapshot] can't find blockheader %s\n",
    //         base_blockhash.ToString());
    //     return false;
    // }

    while (max_secs_to_wait_for_headers > 0) {
        LogPrintf("[loadsnapshot] base_blockhash = %s\n", base_blockhash.ToString());
        snapshot_start_block = WITH_LOCK(::cs_main,
            return chainman.m_blockman.LookupBlockIndex(base_blockhash));
        max_secs_to_wait_for_headers -= 1;

        if (!snapshot_start_block) {
            std::this_thread::sleep_for(std::chrono::seconds(1));
        } else {
            break;
        }
    }

    // // snapshot_start_block = chainman.m_blockman.LookupBlockIndex(base_blockhash);

    if (!snapshot_start_block) {
        LogPrintf("[loadsnapshot] timed out waiting for snapshot start blockheader %s\n",
            base_blockhash.ToString());
        return false;
    }
    
    // Activate the snapshot.
    if (!chainman.ActivateSnapshot(afile, metadata, false)) {
        // std::string error_message = "Unable to load UTXO snapshot " + path.u8string();
        // throw std::runtime_error(error_message);
        LogPrintf("[loadsnapshot] Unable to load UTXO snapshot %s\n", path.u8string());
        return false;
    }

    // Get the new tip and print a log message.
    CBlockIndex* new_tip{WITH_LOCK(::cs_main, return chainman.ActiveTip())};
    LogPrintf("[loadsnashot] Loaded %d coins from snapshot %s at height %d\n",
                metadata.m_coins_count, new_tip->GetBlockHash().ToString(), new_tip->nHeight);

    return true;
}
