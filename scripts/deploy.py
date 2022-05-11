from brownie import CLendingManager, accounts, network, config
from web3 import Web3
import shutil
import sys

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["ganache-local", "development"]


def getAccount(id):
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[id]
    else:
        return accounts.add(config["wallets"]["from_key"])


def deploy_all():
    owner_account = getAccount(0)
    CLendingManager.deploy({"from": owner_account})

    shutil.copyfile(
        "/Users/machhammer/Projekte/CLending/backend/build/deployments/map.json",
        "/Users/machhammer/Projekte/CLending/frontend/src/components/json/map.json",
    )
    shutil.copyfile(
        "/Users/machhammer/Projekte/CLending/backend/build/contracts/CLendingManager.json",
        "/Users/machhammer/Projekte/CLending/frontend/src/components/json/CLendingManager.json",
    )


def executes_test():
    account1 = getAccount(1)
    account2 = getAccount(2)
    account3 = getAccount(3)
    account4 = getAccount(4)
    account5 = getAccount(5)
    cm = CLendingManager[-1]
 
    cm.addDeposit(0, {"from": account1, "value": Web3.toWei(0.01, "ether")})
    cm.addDeposit(1, {"from": account2, "value": Web3.toWei(0.02, "ether")})
    cm.addDeposit(2, {"from": account1, "value": Web3.toWei(0.03, "ether")})
    cm.addDeposit(3, {"from": account3, "value": Web3.toWei(0.04, "ether")})
    
    
    print("*********************************************************")

    addresses = cm.getAllDeposits()
    print(addresses)

    for a in addresses:
        print("Deposit: ", a)


def deploy_and_execute():
    deploy_all()
    executes_test()


def main():
    
    args = sys.argv[1:]
    print(args)

  