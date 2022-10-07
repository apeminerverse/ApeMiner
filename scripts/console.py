from scripts.functions import *

yart_airdrop_ipfs = 'https://bafkreiardihwzjdajophatfgizv6xsfag2bnglqlo2rps77voa56pxedmu.ipfs.nftstorage.link/'
open_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreier72vel7fvsonaalmvpm7pyiurbec45xy6oizmmyruyde6zaidie'
apeminer_ipfs = 'https://nftstorage.link/ipfs/bafkreiamehcsywzt3767uswrombs2qexunn2edlwxurzhduv4j27wdicma'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan, newbie, apeminer = get_accounts(
        active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            # address = gen_accounts(215, "InfinityGauntlet")
            # print('[' + address[:-1] + ']')
            pass

        if active_network in TEST_NETWORKS:
            yarcht_party_nft = ApeMinerInfinityGauntlet[-1]
            public_airdrop_nft = ApeMinerTreasureChest[-1]
            sale_nft = ApeMinerNFT[-1]
        if active_network in REAL_NETWORKS:
            yarcht_party_airdrop = ApeMinerInfinityGauntlet[-1]
            apeminer_airdrop = ApeMinerTreasureChest[-1]
            apuminer_mint = ApeMinerNFT[-1]
    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
