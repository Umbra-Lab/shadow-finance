program shadowfi_token_one_v1_1.aleo {
    const MAX_MINT_AMOUNT_ONE: u64 = 100_000u64;
    const SUPPLY_CAP_ONE: u64 = 100_000_000_000u64;

    mapping supply_one: bool => u64;
    mapping balances_one: address => u64;

    record ONE {
        owner: address,
        amount: u64,
    }

    transition mint_one(owner: address, amount: u64) -> ONE {
        assert(amount <= MAX_MINT_AMOUNT_ONE);

        return ONE {
            owner,
            amount,
        } then finalize(amount);
    }
    finalize mint_one(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_one, true, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP_ONE);

        Mapping::set(supply_one, true, new_supply);
    }

    transition transfer_one(token: ONE, receiver: address, amount: u64) -> (ONE, ONE) {
        let remaining: ONE = ONE {
            owner: token.owner,
            amount: token.amount - amount,
        };

        let transferred: ONE = ONE {
            owner: receiver,
            amount,
        };

        return (remaining, transferred);
    }

    transition transfer_public_one(receiver: address, amount: u64) {
        return then finalize(self.caller, receiver, amount);
    }
    finalize transfer_public_one(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_one, owner);
        Mapping::set(balances_one, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_one, owner, 0u64);
        Mapping::set(balances_one, receiver, receiver_balance + amount);
    }

    transition deposit_one(token: ONE, amount: u64) -> ONE {
        let remaining: ONE = ONE {
            owner: token.owner,
            amount: token.amount - amount,
        };

        return remaining then finalize(self.caller, amount);
    }
    finalize deposit_one(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_one, owner, 0u64);
        Mapping::set(balances_one, owner, balance + amount);
    }

    transition withdraw_one(receiver: address, amount: u64) -> ONE {
        let token: ONE = ONE {
            owner: receiver,
            amount,
        };

        return token then finalize(self.caller, amount);
    }
    finalize withdraw_one(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_one, owner);
        Mapping::set(balances_one, owner, balance - amount);
    }
}
