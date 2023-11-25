program shadowfi_token_zero_v1_1.aleo {
    const MAX_MINT_AMOUNT_ZERO: u64 = 100_000u64;
    const SUPPLY_CAP_ZERO: u64 = 100_000_000_000u64;

    mapping supply_zero: bool => u64;
    mapping balances_zero: address => u64;

    record ZERO {
        owner: address,
        amount: u64,
    }

    transition mint_zero(owner: address, amount: u64) -> ZERO {
        assert(amount <= MAX_MINT_AMOUNT_ZERO);

        return ZERO {
            owner,
            amount,
        } then finalize(amount);
    }
    finalize mint_zero(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_zero, true, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP_ZERO);

        Mapping::set(supply_zero, true, new_supply);
    }

    transition transfer_zero(token: ZERO, receiver: address, amount: u64) -> (ZERO, ZERO) {
        let remaining: ZERO = ZERO {
            owner: token.owner,
            amount: token.amount - amount,
        };

        let transferred: ZERO = ZERO {
            owner: receiver,
            amount,
        };

        return (remaining, transferred);
    }

    transition transfer_public_zero(receiver: address, amount: u64) {
        return then finalize(self.caller, receiver, amount);
    }
    finalize transfer_public_zero(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_zero, owner);
        Mapping::set(balances_zero, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_zero, owner, 0u64);
        Mapping::set(balances_zero, receiver, receiver_balance + amount);
    }

    transition deposit_zero(token: ZERO, amount: u64) -> ZERO {
        let remaining: ZERO = ZERO {
            owner: token.owner,
            amount: token.amount - amount,
        };

        return remaining then finalize(self.caller, amount);
    }
    finalize deposit_zero(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_zero, owner, 0u64);
        Mapping::set(balances_zero, owner, balance + amount);
    }

    transition withdraw_zero(receiver: address, amount: u64) -> ZERO {
        let token: ZERO = ZERO {
            owner: receiver,
            amount,
        };

        return token then finalize(self.caller, amount);
    }
    finalize withdraw_zero(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_zero, owner);
        Mapping::set(balances_zero, owner, balance - amount);
    }
}
