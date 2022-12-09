module ItemCommon
  def query_all_json(factory, items)
    obj = []
    items.each do |item|
      obj << {
        :factory => idencode(factory.id),
        :id => idencode(item.id),
        :idno => item.idno,
        :name => item.name,
        :mdno => item.mdno,
        :unit => item.unit,
        :fct  => item.fct,
        :count => item.count
      }
    end
    obj
  end
end
