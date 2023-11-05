program shadowfi_token_light_v1_1.aleo {
    const MAX_MINT_AMOUNT_LIGHT: u64 = 100_000u64;
    const SUPPLY_CAP_LIGHT: u64 = 100_000_000_000u64;

    mapping supply_light: u8 => u64;
    mapping balances_light: address => u64;

    record LightToken {
        owner: address,
        amount: u64,
    }

    transition mint_light(owner: address, amount: u64) -> LightToken {
        assert(amount <= MAX_MINT_AMOUNT_LIGHT);

        return LightToken {
            owner,
            amount,
        } then finalize(amount);
    }
    finalize mint_light(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_light, 0u8, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP_LIGHT);

        Mapping::set(supply_light, 0u8, new_supply);
    }

    transition transfer_light(token: LightToken, receiver: address, amount: u64) -> (LightToken, LightToken) {
        let remaining: LightToken = LightToken {
            owner: token.owner,
            amount: token.amount - amount,
        };

        let transferred: LightToken = LightToken {
            owner: receiver,
            amount,
        };

        return (remaining, transferred);
    }

    transition transfer_public_light(receiver: address, amount: u64) {
        return then finalize(self.caller, receiver, amount);
    }
    finalize transfer_public_light(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_light, owner);
        Mapping::set(balances_light, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_light, owner, 0u64);
        Mapping::set(balances_light, receiver, receiver_balance + amount);
    }

    transition deposit_light(token: LightToken, amount: u64) -> LightToken {
        let remaining: LightToken = LightToken {
            owner: token.owner,
            amount: token.amount - amount,
        };

        return remaining then finalize(self.caller, amount);
    }
    finalize deposit_light(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_light, owner, 0u64);
        Mapping::set(balances_light, owner, balance + amount);
    }

    transition withdraw_light(receiver: address, amount: u64) -> LightToken {
        let token: LightToken = LightToken {
            owner: receiver,
            amount,
        };

        return token then finalize(self.caller, amount);
    }
    finalize withdraw_light(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_light, owner);
        Mapping::set(balances_light, owner, balance - amount);
    }
}
