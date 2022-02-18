class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 防止find_by_sql sql注入危险
  def self.escape_sql(clause, *rest)
    self.send(:sanitize_sql_array, rest.empty? ? clause : ([clause] + rest))
  end

  def destroy
    self.is_deleted = true
    self.save
  end

  def self.default_page(params)
    page = params[:page].to_i rescue 1
    size = params[:size].to_i rescue 10
    page = 1 if page < 1
    size = 10 if size < 1
    [page, size]
  end

  def self.map_fields(fields)
		fields.split(",").map{|x| x.to_sym}
	end

end
