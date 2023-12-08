program shadowfi_token_zec_v1_1.aleo {
    const MAX_MINT_AMOUNT_ZEC: u64 = 100_000u64;
    const SUPPLY_CAP_ZEC: u64 = 100_000_000_000u64;

    mapping supply_zec: bool => u64;
    mapping balances_zec: address => u64;

    record ZEC {
        owner: address,
        amount: u64,
    }

    transition mint_zec(owner: address, amount: u64) -> ZEC {
        assert(amount <= MAX_MINT_AMOUNT_ZEC);

        return ZEC {
            owner,
            amount,
        } then finalize(amount);
    }
    finalize mint_zec(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_zec, true, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP_ZEC);

        Mapping::set(supply_zec, true, new_supply);
    }

    transition transfer_zec(token: ZEC, receiver: address, amount: u64) -> (ZEC, ZEC) {
        let remaining: ZEC = ZEC {
            owner: token.owner,
            amount: token.amount - amount,
        };

        let transferred: ZEC = ZEC {
            owner: receiver,
            amount,
        };

        return (remaining, transferred);
    }

    transition transfer_public_zec(receiver: address, amount: u64) {
        return then finalize(self.caller, receiver, amount);
    }
    finalize transfer_public_zec(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_zec, owner);
        Mapping::set(balances_zec, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_zec, owner, 0u64);
        Mapping::set(balances_zec, receiver, receiver_balance + amount);
    }

    transition deposit_zec(token: ZEC, amount: u64) -> ZEC {
        let remaining: ZEC = ZEC {
            owner: token.owner,
            amount: token.amount - amount,
        };

        return remaining then finalize(self.caller, amount);
    }
    finalize deposit_zec(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_zec, owner, 0u64);
        Mapping::set(balances_zec, owner, balance + amount);
    }

    transition withdraw_zec(receiver: address, amount: u64) -> ZEC {
        let token: ZEC = ZEC {
            owner: receiver,
            amount,
        };

        return token then finalize(self.caller, amount);
    }
    finalize withdraw_zec(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_zec, owner);
        Mapping::set(balances_zec, owner, balance - amount);
    }
}
