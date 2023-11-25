import shadowfi_token_zero_v1_1.leo;
import shadowfi_token_one_v1_1.leo;

program shadowfi_vamm_zeroone_v1_1.aleo {    
    mapping supply_zeroone: bool => u64;
    mapping reserves_zeroone: bool => u64;
    mapping balances_zeroone: u64 => u64;

    record ZEROONE {
        owner: address,
        claim: u64,
    }

    inline math_min(n1: u64, n2: u64) -> u64 {
        return n1 < n2 ? n1 : n2;
    }

    function square_root(x: u64) -> u64 {
        let z: u64 = (x + 1u64) / 2u64;
        let y: u64 = x;

        for i: u8 in 0u8..42u8 {
            if (z >= y) {
                return y;
            }

            y = z;
            z = (x / z + z) / 2u64;
        }

        return 0u64;
    }

    transition init_pool_zeroone(owner: address, claim: u64, token0: shadowfi_token_zero_v1_1.leo/ZERO, amount0: u64, token1: shadowfi_token_one_v1_1.leo/ONE, amount1: u64) -> (shadowfi_token_zero_v1_1.leo/ZERO, shadowfi_token_one_v1_1.leo/ONE, ZEROONE) {
        let remaining0: ZERO = shadowfi_token_zero_v1_1.leo/deposit_zero(token0, amount0);
        let remaining1: ONE = shadowfi_token_one_v1_1.leo/deposit_one(token1, amount1);

        let token: ZEROONE = ZEROONE {
            owner,
            claim,
        };

        let initial_lp: u64 = square_root(amount0 * amount1) - 1000u64;

        return (remaining0, remaining1, token) then finalize(claim, amount0, amount1, initial_lp);
    }
    finalize init_pool_zeroone(owner: u64, token0: u64, token1: u64, initial_lp: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_zeroone, true, 0u64);

        assert_eq(total_supply, 0u64);

        Mapping::set(reserves_zeroone, false, token0);
        Mapping::set(reserves_zeroone, true, token1);

        Mapping::set(supply_zeroone, true, initial_lp);

        Mapping::set(balances_zeroone, owner, initial_lp);
    }

    transition init_lp_zeroone(owner: address, claim: u64, token0: shadowfi_token_zero_v1_1.leo/ZERO, amount0: u64, token1: shadowfi_token_one_v1_1.leo/ONE, amount1: u64) -> (shadowfi_token_zero_v1_1.leo/ZERO, shadowfi_token_one_v1_1.leo/ONE, ZEROONE) {
        let remaining0: ZERO = shadowfi_token_zero_v1_1.leo/deposit_zero(token0, amount0);
        let remaining1: ONE = shadowfi_token_one_v1_1.leo/deposit_one(token1, amount1);

        let token: ZEROONE = ZEROONE {
            owner,
            claim,
        };

        return (remaining0, remaining1, token) then finalize(claim, amount0, amount1);
    }
    finalize init_lp_zeroone(owner: u64, token0: u64, token1: u64) {
        assert(!Mapping::contains(balances_zeroone, owner));
        let total_supply: u64 = Mapping::get(supply_zeroone, true);

        assert_neq(total_supply, 0u64);

        let reserve0: u64 = Mapping::get(reserves_zeroone, false);
        let reserve1: u64 = Mapping::get(reserves_zeroone, true);
        
        let lp0: u64 = (token0 * total_supply) / reserve0;
        let lp1: u64 = (token1 * total_supply) / reserve1;

        let lp: u64 = math_min(lp0, lp1);

        Mapping::set(reserves_zeroone, false, reserve0 + token0);
        Mapping::set(reserves_zeroone, true, reserve1 + token1);

        Mapping::set(supply_zeroone, true, total_supply + lp);

        Mapping::set(balances_zeroone, owner, lp);
    }

    transition add_lp_zeroone(token: ZEROONE, token0: shadowfi_token_zero_v1_1.leo/ZERO, amount0: u64, token1: shadowfi_token_one_v1_1.leo/ONE, amount1: u64) -> (shadowfi_token_zero_v1_1.leo/ZERO, shadowfi_token_one_v1_1.leo/ONE, ZEROONE) {
        let remaining0: ZERO = shadowfi_token_zero_v1_1.leo/deposit_zero(token0, amount0);
        let remaining1: ONE = shadowfi_token_one_v1_1.leo/deposit_one(token1, amount1);

        return (remaining0, remaining1, token) then finalize(token.claim, amount0, amount1);
    }
    finalize add_lp_zeroone(owner: u64, token0: u64, token1: u64) {
        let total_supply: u64 = Mapping::get(supply_zeroone, true);

        assert_neq(total_supply, 0u64);

        let reserve0: u64 = Mapping::get(reserves_zeroone, false);
        let reserve1: u64 = Mapping::get(reserves_zeroone, true);
        
        let lp0: u64 = (token0 * total_supply) / reserve0;
        let lp1: u64 = (token1 * total_supply) / reserve1;

        let lp: u64 = math_min(lp0, lp1);

        Mapping::set(reserves_zeroone, false, reserve0 + token0);
        Mapping::set(reserves_zeroone, true, reserve1 + token1);

        Mapping::set(supply_zeroone, true, total_supply + lp);

        let current_lp: u64 = Mapping::get(balances_zeroone, owner);
        Mapping::set(balances_zeroone, owner, current_lp + lp);
    }

    transition burn_lp_zeroone(receiver: address, token: ZEROONE, amount0: u64, amount1: u64) -> (shadowfi_token_zero_v1_1.leo/ZERO, shadowfi_token_one_v1_1.leo/ONE) {
        let token0: ZERO = shadowfi_token_zero_v1_1.leo/withdraw_zero(receiver, amount0);
        let token1: ONE = shadowfi_token_one_v1_1.leo/withdraw_one(receiver, amount1);

        return then finalize(token.claim, amount0, amount1);
    }
    finalize burn_lp_zeroone(owner: u64, amount0: u64, amount1: u64) {
        let total_supply: u64 = Mapping::get(supply_zeroone, true);

        let lp: u64 = Mapping::get(balances_zeroone, owner);

        let reserve0: u64 = Mapping::get(reserves_zeroone, false);
        let reserve1: u64 = Mapping::get(reserves_zeroone, true);

        assert(amount0 <= (lp * reserve0) / total_supply);
        assert(amount1 <= (lp * reserve1) / total_supply);

        Mapping::set(reserves_zeroone, false, reserve0 - amount0);
        Mapping::set(reserves_zeroone, true, reserve1 - amount1);

        Mapping::set(supply_zeroone, true, total_supply - lp);

        Mapping::remove(balances_zeroone, owner);
    }

    transition swap_to_0_zeroone(receiver: address, token1In: shadowfi_token_one_v1_1.leo/ONE, amount1In: u64, amount0Out: u64) -> (shadowfi_token_zero_v1_1.leo/ZERO, shadowfi_token_one_v1_1.leo/ONE) {
        let token0: ZERO = shadowfi_token_zero_v1_1.leo/withdraw_zero(receiver, amount0Out);
        let token1: ONE = shadowfi_token_one_v1_1.leo/deposit_one(token1In, amount1In);

        return (token0, token1) then finalize(amount1In, amount0Out);
    }
    finalize swap_to_0_zeroone(amount1In: u64, amount0Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_zeroone, false);
        let reserve1: u64 = Mapping::get(reserves_zeroone, true);

        let new_reserve0: u64 = reserve0 - amount0Out;
        let new_reserve1: u64 = reserve1 + amount1In;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_zeroone, false, new_reserve0);
        Mapping::set(reserves_zeroone, true, new_reserve1);
    }

    transition swap_to_1_zeroone(receiver: address, token0In: shadowfi_token_zero_v1_1.leo/ZERO, amount0In: u64, amount1Out: u64) -> (shadowfi_token_zero_v1_1.leo/ZERO, shadowfi_token_one_v1_1.leo/ONE) {        
        let token0: ZERO = shadowfi_token_zero_v1_1.leo/deposit_zero(token0In, amount0In);
        let token1: ONE = shadowfi_token_one_v1_1.leo/withdraw_one(receiver, amount1Out);

        return (token0, token1) then finalize(amount0In, amount1Out);
    }
    finalize swap_to_1_zeroone(amount0In: u64, amount1Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_zeroone, false);
        let reserve1: u64 = Mapping::get(reserves_zeroone, true);

        let new_reserve0: u64 = reserve0 + amount0In;
        let new_reserve1: u64 = reserve1 - amount1Out;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_zeroone, false, new_reserve0);
        Mapping::set(reserves_zeroone, true, new_reserve1);
    }
}
