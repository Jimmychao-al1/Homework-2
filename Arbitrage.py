from itertools import permutations

def swap_amount_in(amount_in, reserve_in, reserve_out):
    """Calculate the amount of tokens received after a swap."""
    fee = 0.003
    amount_in_with_fee = amount_in * (1 - fee)
    numerator = amount_in_with_fee * reserve_out
    denominator = reserve_in + amount_in_with_fee
    return numerator / denominator

def find_profitable_path(liquidity, start_token, end_token, start_amount):
    paths = list(permutations(liquidity.keys(), 3))
    profitable_paths = []

    for path in paths:
        # Start from tokenB and end with tokenB to find a loop
        if path[0][0] == start_token and path[-1][1] == end_token:
            current_amount = start_amount
            valid_path = True
            
            # Go through each swap in the path
            for i in range(len(path)):
                token_in, token_out = path[i]
                if (token_in, token_out) not in liquidity:
                    valid_path = False
                    break
                reserve_in, reserve_out = liquidity[(token_in, token_out)]
                current_amount = swap_amount_in(current_amount, reserve_in, reserve_out)
            
            # If the final amount is greater than 20, we found a profitable path
            if valid_path and current_amount > 20:
                profitable_paths.append((path, current_amount))

    return profitable_paths

def main():
    liquidity = {
        ("tokenA", "tokenB"): (17, 10),
        ("tokenA", "tokenC"): (11, 7),
        ("tokenA", "tokenD"): (15, 9),
        ("tokenA", "tokenE"): (21, 5),
        ("tokenB", "tokenC"): (36, 4),
        ("tokenB", "tokenD"): (13, 6),
        ("tokenB", "tokenE"): (25, 3),
        ("tokenC", "tokenD"): (30, 12),
        ("tokenC", "tokenE"): (10, 8),
        ("tokenD", "tokenE"): (60, 25),
    }
    
    start_token = 'tokenB'
    end_token = 'tokenB'
    start_amount = 5

    profitable_paths = find_profitable_path(liquidity, start_token, end_token, start_amount)
    
    if profitable_paths:
        for path, amount in profitable_paths:
            print(f"Profitable path found: {'->'.join([p[0] for p in path])}->{end_token}, tokenB balance={amount:.6f}")
    else:
        print("No profitable arbitrage path found.")

if __name__ == "__main__":
    main()
