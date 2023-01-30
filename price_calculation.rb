require './models/campaign.rb'
require './models/order.rb'

# 計算規則
#
# 1. 消費未滿 $1,500, 則須增加 $60 運費
# 2. 若消費期間有超過兩個優惠活動，取最優者折扣 
# 3. 運費計算在優惠折抵之後
#
# Please implemenet the following methods.
# Additional helper methods are recommended.

class PriceCalculation
  def initialize(order_id)
    raise Order::NotFound if !Order.find(order_id)
    @order = Order.orders.filter {|x| x.id == order_id}.first
  end

  def total
    campaigns = Campaign.campaigns.filter {|x| x.start_date <= @order.order_date && x.end_date >= @order.order_date}

    if campaigns.any?
      discount_ratio = campaigns.map {|x| x.discount_ratio}.max
    else
      discount_ratio = 0
    end
    
    discount = (100 - discount_ratio) / 100.0
    free_shipment? ? @order.price * discount : @order.price * discount + 60
  end

  def free_shipment?
    @order.price >= 1500
  end
end