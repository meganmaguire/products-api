require_relative '../models/product'

class ProductStore
  class << self
    def init!
      @products = {}
      @next_id = 0
    end

    def next_id
      @next_id += 1
    end

    def save(product)
      @products[product.id] = product
    end

    def find(id)
      @products[id.to_i]
    end

    def all
      @products.values
    end
  end

  init!
end
