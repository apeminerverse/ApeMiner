from scripts.functions import *

yart_airdrop_ipfs = 'ipfs://bafybeigtbwecpthwzq4nj4gkc7tfv4c2v4adh26ndw5khboaq4sghqgcva'
open_airdrop_ipfs = 'ipfs://bafkreihpaqicot6kjkpda676jp2poajzbbckgbc4ue67b6wnbremljxu3e'
apeminer_ipfs = 'ipfs://bafkreiamehcsywzt3767uswrombs2qexunn2edlwxurzhduv4j27wdicma'
mjolnir_ipfs = 'ipfs://bafybeidhaiyqhzlmwldshgdscirqb3lhdo33p24sk2n5cwf7jz7xjuqckq'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan, newbie, apeminer = get_accounts(
        active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            # nft = YachtPartyAirdrop.deploy(url, '', addr(admin))
            # yarcht_party_nft = ApeMinerInfinityGauntlet.deploy(yart_airdrop_ipfs,
            #                                                    addr(admin))
            # public_airdrop_nft = ApeMinerTreasureChest.deploy("", open_airdrop_ipfs,
            #                                                   addr(admin))
            # sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs, 0.5*10**18,
            #                               addr(admin))
            mjolnir = ApeMinerMjolnir.deploy(mjolnir_ipfs, addr(admin))
            mjolnir.mint([iwan, creator, consumer, admin], addr(admin))
            mjolnir.mint(admin, 10, addr(admin))

            # tx = sale_nft.startPublicSale(addr(admin))
            # tx.wait(1)
            # tx = public_airdrop_nft.startAirdrop(addr(admin))
            # tx.wait(1)

            # yarcht_party_nft.airdropMint(
            #     [iwan, creator, consumer, admin], addr(admin))
            # public_airdrop_nft.airdropMint(addr(iwan))
            # sale_nft.publicSaleMint(5, addr2(iwan, 5*10**18))

        if active_network in TEST_NETWORKS:
            mjolnir = ApeMinerMjolnir[-1]
            mjolnir.mint([iwan, creator, consumer, admin], addr(admin))
            mjolnir.mint(admin, 10, addr(admin))
            # tx = public_airdrop_nft.startAirdrop(addr(admin))
            # tx.wait(1)
            # tx = sale_nft.startPublicSale(addr(admin))
            # tx.wait(1)

            # yarcht_party_nft.airdropMint(
            #     [iwan, creator, consumer, admin], addr(admin))
            # public_airdrop_nft.airdropMint(addr(creator))
            # sale_nft.publicSaleMint(1, addr2(creator, 0.5*10**18))

        if active_network in REAL_NETWORKS:
            # mjolnir = ApeMinerMjolnir[-1]
            # mjolnir.mint([iwan, creator, consumer, admin], addr(apeminer))
            # mjolnir.mint(admin, 10, addr(apeminer))

            # tx = sale_nft.startPublicSale(addr(admin))
            # tx.wait(1)
            # tx = public_airdrop_nft.startAirdrop(addr(admin))
            # tx.wait(1)

            # yarcht_party_nft.airdropMint(
            #     [iwan, creator, consumer, admin], addr(admin))
            # public_airdrop_nft.airdropMint(addr(iwan))
            # sale_nft.publicSaleMint(5, addr2(iwan, 5*10**18))

            yarcht_party_nft = ApeMinerInfinityGauntlet[-1]
            yarcht_party_nft.mint(
                [iwan, creator, apeminer, consumer, '0xB9148e2CAb998462b3A7803d35212796CEFb4cf7'], addr(apeminer))

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
