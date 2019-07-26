def consolidate_cart(cart)
  new_has = {}
  for k in cart
    for i,j in k
    new_has[i] = {price: j[:price], clearance: j[:clearance],count: cart.map{|record| record[i]}.compact.size }
    end
  end
return new_has 
end


def apply_coupons (cart, coupons)
  coupons_items = []
  coupons.each {|h| coupons_items.append(h[:item])}
  
  card_items = []
  cart.each {|k,j| card_items.append(k)}
  
  no_coupon_items = card_items - coupons_items 
  
  coupon_items = coupons_items & card_items
  
  if coupons_items & card_items == []
    return cart
  end

  new_hash = {}
  for i in no_coupon_items
    new_hash[i] = cart[i]
  end
  
  for i in 0..coupons.length-1
    coupons_logic = coupons[i][:num]
    coupons_price = coupons[i][:cost]
    item = coupons[i][:item]
    if cart[item][:count]  >= coupons_logic
      new_hash[item+" W/COUPON"] = {:price => (coupons_price/coupons_logic).round(2), :clearance => cart[item][:clearance],  :count => coupons_logic}
      remain = cart[item][:count]  - coupons_logic 
      while remain >= coupons_logic
        new_hash[item+" W/COUPON"] = {:price => (coupons_price/coupons_logic).round(2), :clearance => cart[item][:clearance],  :count => new_hash[item+" W/COUPON"][:count ]+coupons_logic}
        remain = remain  - coupons_logic 
      end
    end
    if remain>=0
      new_hash[item] = {:price =>cart[item][:price] , :clearance => cart[item][:clearance],  :count => remain}
    end
  end
  return new_hash
end

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

def apply_clearance(cart)
  new_cart = deep_copy(cart)
  for i,j in new_cart
    if new_cart[i][:clearance] 
      new_cart[i][:price]  = new_cart[i][:price]- new_cart[i][:price] *0.2  
    end
  end
  return new_cart
end



def checkout(cart, coupons)
  cart_conso = consolidate_cart(cart)
  
  cart_conso_coup = apply_coupons(cart_conso, coupons)
  cart_conso_coup_dis = apply_clearance(cart_conso_coup)
  total_pay = 0
  for i, j in cart_conso_coup_dis
    total_pay += cart_conso_coup_dis[i][:price]*cart_conso_coup_dis[i][:count]
  end
  if total_pay >=100
    output = total_pay -total_pay*0.1
    return output
  else
    output = total_pay
    return output
  end
end
