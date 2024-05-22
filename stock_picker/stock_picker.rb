def stock_picker(array)
    best_days = Array.new(2,0)
    max_profit = 0
    array.each_with_index do |buy, buy_index|
        array.each_with_index do |sell, sell_index|
            if buy_index < sell_index
                profit = sell - buy
                if profit > max_profit
                    max_profit = profit
                    best_days[0] = buy_index
                    best_days[1] = sell_index
                end
            end
        end 
    end
    best_days
end

p stock_picker([17,3,6,9,15,8,6,1,10])


