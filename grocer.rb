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
  
  if coupons_items & card_items == []
    return cart
  end
  
  if coupons.length == 0
    return cart
  else
    new_hash = {}
    for i,j in cart
#       p i
#       p j 
      relevent_coupons = coupons.each do |h| 
        if h[:item] == i

          coupons_logic = h[:num]
          coupons_price = h[:cost]
#           p coupons_logic
#           p coupons_price
#           p j[:count]
            if j[:count]  >= coupons_logic
              new_hash[i+" W/COUPON"] = {:price => coupons_price/coupons_logic, :clearance => j[:clearance],  :count => coupons_logic}
              remain = j[:count]   - coupons_logic 
              while remain >= coupons_logic
                new_hash[i+" W/COUPON"] = {:price => coupons_price/coupons_logic, :clearance => j[:clearance],  :count => new_hash[i+" W/COUPON"][:count ]+coupons_logic}
                remain = remain  - coupons_logic 
#                p new_hash
#               p "_________"
              end
              if remain>=0
                  new_hash[i] = {:price =>j[:price] , :clearance => j[:clearance],  :count => remain}
#               p new_hash
#               p "_________"
#               p "_________"
              end
          elsif h[:item] != i
            new_hash[i] = {:price =>j[:price] , :clearance => j[:clearance],  :count => j[:count]}
        end
        end
      end 
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
