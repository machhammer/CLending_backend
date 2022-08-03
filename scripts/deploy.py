from brownie import CLendingManager, accounts, network, config
from web3 import Web3
import shutil
import sys
import os

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["ganache-local", "development"]


def getAccount(id):
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[id]
    else:
        return accounts.add(config["wallets"]["from_key"])


def deploy_all():
    owner_account = getAccount(0)
    CLendingManager.deploy({"from": owner_account})

    directory = "/Users/machhammer/Projekte/CLending/frontend/src/components/json"

    if not os.path.exists(directory):
        os.makedirs(directory)

    shutil.copyfile(
        "/Users/machhammer/Projekte/CLending/backend/build/deployments/map.json",
        "/Users/machhammer/Projekte/CLending/frontend/src/components/json/map.json",
    )
    shutil.copyfile(
        "/Users/machhammer/Projekte/CLending/backend/build/contracts/CLendingManager.json",
        "/Users/machhammer/Projekte/CLending/frontend/src/components/json/CLendingManager.json",
    )


def executes_test():
    account0 = getAccount(0)
    account1 = getAccount(1)
    account2 = getAccount(2)
    account3 = getAccount(3)
    account4 = getAccount(4)
    account5 = getAccount(5)
    cm = CLendingManager[-1]
 
    cm.stake(0, {"from": account1, "value": Web3.toWei(0.01, "ether")})
    cm.stake(1, {"from": account2, "value": Web3.toWei(0.01, "ether")})
    cm.stake(2, {"from": account2, "value": Web3.toWei(0.03, "ether")})
    cm.stake(3, {"from": account3, "value": Web3.toWei(0.04, "ether")})
    
    cm.collateral(1, {"from": account1, "value": Web3.toWei(0.4, "ether")})
    
    print("Owner: ", cm.getOwner())

    print("Borrower: ", account3)

    print("**************************")
    elements = cm.getElementByElementTypeAndAddress(2, account3)
    for e in elements:
        print(e)

    print("************************** Borrow 1")
    tx = cm.borrow(Web3.toWei(0.4, "ether"), account1, {"from": account1})

    cm.collateral(3, {"from": account3, "value": Web3.toWei(0.4, "ether")})

    print("************************** Borrow 2")
    tx = cm.borrow(Web3.toWei(0.3, "ether"), account3, {"from": account3})

def deploy_and_execute():
    deploy_all()
    executes_test()


def main():
    
    args = sys.argv[1:]
    print(args)

  