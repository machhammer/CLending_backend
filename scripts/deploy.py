from brownie import CLendingManager, accounts, network, config
from web3 import Web3
import shutil

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["ganache-local"]


def getOwnerAccount():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def getBorrowerAccount(id):
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[id]
    else:
        return accounts.add(config["wallets"]["from_key"])


def deploy_all(account):
    CLendingManager.deploy({"from": account})
    shutil.copyfile(
        "/Users/machhammer/Projekte/CLending/backend/build/deployments/map.json",
        "/Users/machhammer/Projekte/CLending/frontend/src/components/json/map.json",
    )
    shutil.copyfile(
        "/Users/machhammer/Projekte/CLending/backend/build/contracts/CLendingManager.json",
        "/Users/machhammer/Projekte/CLending/frontend/src/components/json/CLendingManager.json",
    )


def main():
    owner_account = getOwnerAccount()
    borrower_account = getBorrowerAccount(2)
    deposit_account = getBorrowerAccount(3)

    deploy_all(owner_account)
    cm = CLendingManager[-1]
    print(cm)
    cm.depositAmount({"from": deposit_account, "value": Web3.toWei(1, "ether")})
    print(cm.getDepositBalance())
