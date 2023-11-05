import shadowfi_token_light_v1_1.leo;
import shadowfi_token_shadow_v1_1.leo;

program shadowfi_amm_volatile_v1_0.aleo {    
    mapping supply_shadowfi: u8 => u64;
    mapping reserves_shadowfi: u8 => u64;
    mapping balances_shadowfi: field => u64;

    record LightShadowToken {
        owner: address,
        claim: field,
    }

    inline math_min(n1: u64, n2: u64) -> u64 {
        return n1 < n2 ? n1 : n2;
    }

    function square_root(x: u64) -> u64 {
        let z: u64 = (x + 1u64) / 2u64;
        let y: u64 = x;

        for i: u8 in 0u8..42u8 {
            if(z >= y) {
                return y;
            }

            y = z;
            z = (x / z + z) / 2u64;
        }

        return 0u64;
    }

    transition init_pool_shadowfi(receiver: address, token0: shadowfi_token_light_v1_1.leo/LightToken, amount0: u64, token1: shadowfi_token_shadow_v1_1.leo/ShadowToken, amount1: u64) -> (shadowfi_token_light_v1_1.leo/LightToken, shadowfi_token_shadow_v1_1.leo/ShadowToken, LightShadowToken) {
        let remaining0: LightToken = shadowfi_token_light_v1_1.leo/deposit_light(token0, amount0);
        let remaining1: ShadowToken = shadowfi_token_shadow_v1_1.leo/deposit_shadow(token1, amount1);
        let address_hash: field = Poseidon2::hash_to_field(receiver);
        let token: LightShadowToken = LightShadowToken {
            owner: receiver,
            claim: address_hash,
        };

        let initial_lp: u64 = square_root(amount0 * amount1) - 1000u64;

        return (remaining0, remaining1, token) then finalize(address_hash, amount0, amount1, initial_lp);
    }
    finalize init_pool_shadowfi(owner: field, token0: u64, token1: u64, initial_lp: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_shadowfi, 0u8, 0u64);

        assert_eq(total_supply, 0u64);

        Mapping::set(reserves_shadowfi, 0u8, token0);
        Mapping::set(reserves_shadowfi, 1u8, token1);

        Mapping::set(supply_shadowfi, 0u8, initial_lp);

        Mapping::set(balances_shadowfi, owner, initial_lp);
    }

    transition init_lp_shadowfi(receiver: address, token0: shadowfi_token_light_v1_1.leo/LightToken, amount0: u64, token1: shadowfi_token_shadow_v1_1.leo/ShadowToken, amount1: u64) -> (shadowfi_token_light_v1_1.leo/LightToken, shadowfi_token_shadow_v1_1.leo/ShadowToken, LightShadowToken) {
        let remaining0: LightToken = shadowfi_token_light_v1_1.leo/deposit_light(token0, amount0);
        let remaining1: ShadowToken = shadowfi_token_shadow_v1_1.leo/deposit_shadow(token1, amount1);
        let address_hash: field = Poseidon2::hash_to_field(receiver);
        let token: LightShadowToken = LightShadowToken {
            owner: receiver,
            claim: address_hash,
        };

        return (remaining0, remaining1, token) then finalize(address_hash, amount0, amount1);
    }
    finalize init_lp_shadowfi(owner: field, token0: u64, token1: u64) {
        let total_supply: u64 = Mapping::get(supply_shadowfi, 0u8);

        assert_neq(total_supply, 0u64);

        let reserve0: u64 = Mapping::get(reserves_shadowfi, 0u8);
        let reserve1: u64 = Mapping::get(reserves_shadowfi, 1u8);
        
        let lp0: u64 = (token0 * total_supply) / reserve0;
        let lp1: u64 = (token1 * total_supply) / reserve1;

        let lp: u64 = math_min(lp0, lp1);

        Mapping::set(reserves_shadowfi, 0u8, reserve0 + token0);
        Mapping::set(reserves_shadowfi, 1u8, reserve1 + token1);

        Mapping::set(supply_shadowfi, 0u8, total_supply + lp);

        Mapping::set(balances_shadowfi, owner, lp);
    }

    transition add_lp_shadowfi(token: LightShadowToken, token0: shadowfi_token_light_v1_1.leo/LightToken, amount0: u64, token1: shadowfi_token_shadow_v1_1.leo/ShadowToken, amount1: u64) -> (shadowfi_token_light_v1_1.leo/LightToken, shadowfi_token_shadow_v1_1.leo/ShadowToken) {
        let remaining0: LightToken = shadowfi_token_light_v1_1.leo/deposit_light(token0, amount0);
        let remaining1: ShadowToken = shadowfi_token_shadow_v1_1.leo/deposit_shadow(token1, amount1);

        return (remaining0, remaining1) then finalize(token.claim, amount0, amount1);
    }
    finalize add_lp_shadowfi(owner: field, token0: u64, token1: u64) {
        let total_supply: u64 = Mapping::get(supply_shadowfi, 0u8);

        assert_neq(total_supply, 0u64);

        let reserve0: u64 = Mapping::get(reserves_shadowfi, 0u8);
        let reserve1: u64 = Mapping::get(reserves_shadowfi, 1u8);
        
        let lp0: u64 = (token0 * total_supply) / reserve0;
        let lp1: u64 = (token1 * total_supply) / reserve1;

        let lp: u64 = math_min(lp0, lp1);

        Mapping::set(reserves_shadowfi, 0u8, reserve0 + token0);
        Mapping::set(reserves_shadowfi, 1u8, reserve1 + token1);

        Mapping::set(supply_shadowfi, 0u8, total_supply + lp);

        let current_lp: u64 = Mapping::get(balances_shadowfi, owner);
        Mapping::set(balances_shadowfi, owner, current_lp + lp);
    }

    transition burn_lp_shadowfi(receiver: address, token: LightShadowToken, amount0: u64, amount1: u64) -> (shadowfi_token_light_v1_1.leo/LightToken, shadowfi_token_shadow_v1_1.leo/ShadowToken) {
        let token0: LightToken = shadowfi_token_light_v1_1.leo/withdraw_light(receiver, amount0);
        let token1: ShadowToken = shadowfi_token_shadow_v1_1.leo/withdraw_shadow(receiver, amount1);

        return then finalize(token.claim, amount0, amount1);
    }
    finalize burn_lp_shadowfi(owner: field, amount0: u64, amount1: u64) {
        let total_supply: u64 = Mapping::get(supply_shadowfi, 0u8);

        let lp: u64 = Mapping::get(balances_shadowfi, owner);

        let reserve0: u64 = Mapping::get(reserves_shadowfi, 0u8);
        let reserve1: u64 = Mapping::get(reserves_shadowfi, 1u8);

        assert(amount0 <= (lp * reserve0) / total_supply);
        assert(amount1 <= (lp * reserve1) / total_supply);

        Mapping::set(reserves_shadowfi, 0u8, reserve0 - amount0);
        Mapping::set(reserves_shadowfi, 1u8, reserve1 - amount1);

        Mapping::set(supply_shadowfi, 0u8, total_supply - lp);

        Mapping::remove(balances_shadowfi, owner);
    }

    transition swap_to_0_shadowfi(receiver: address, token1In: shadowfi_token_shadow_v1_1.leo/ShadowToken, amount1In: u64, amount0Out: u64) -> (shadowfi_token_light_v1_1.leo/LightToken, shadowfi_token_shadow_v1_1.leo/ShadowToken) {
        assert_neq(amount0Out, 0u64);
        assert_neq(amount1In, 0u64);
        
        let token0: LightToken = shadowfi_token_light_v1_1.leo/withdraw_light(receiver, amount0Out);
        let token1: ShadowToken = shadowfi_token_shadow_v1_1.leo/deposit_shadow(token1In, amount1In);

        return (token0, token1) then finalize(amount1In, amount0Out);
    }
    finalize swap_to_0_shadowfi(amount1In: u64, amount0Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_shadowfi, 0u8);
        let reserve1: u64 = Mapping::get(reserves_shadowfi, 1u8);

        let new_reserve0: u64 = reserve0 - amount0Out;
        let new_reserve1: u64 = reserve1 + amount1In;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_shadowfi, 0u8, new_reserve0);
        Mapping::set(reserves_shadowfi, 1u8, new_reserve1);
    }

    transition swap_to_1_shadowfi(receiver: address, token0In: shadowfi_token_light_v1_1.leo/LightToken, amount0In: u64, amount1Out: u64) -> (shadowfi_token_light_v1_1.leo/LightToken, shadowfi_token_shadow_v1_1.leo/ShadowToken) {
        assert_neq(amount0In, 0u64);
        assert_neq(amount1Out, 0u64);
        
        let token0: LightToken = shadowfi_token_light_v1_1.leo/deposit_light(token0In, amount0In);
        let token1: ShadowToken = shadowfi_token_shadow_v1_1.leo/withdraw_shadow(receiver, amount1Out);

        return (token0, token1) then finalize(amount0In, amount1Out);
    }
    finalize swap_to_1_shadowfi(amount0In: u64, amount1Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_shadowfi, 0u8);
        let reserve1: u64 = Mapping::get(reserves_shadowfi, 1u8);

        let new_reserve0: u64 = reserve0 + amount0In;
        let new_reserve1: u64 = reserve1 - amount1Out;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_shadowfi, 0u8, new_reserve0);
        Mapping::set(reserves_shadowfi, 1u8, new_reserve1);
    }
}
