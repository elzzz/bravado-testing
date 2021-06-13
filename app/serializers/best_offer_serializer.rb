class BestOfferSerializer < ApplicationSerializer
  attributes :id, :price, :company, :label

  def label
    case object[:label]
    when 0
      'local_perfect_match'
    when 1
      'api_perfect_match'
    when 2
      'local_good_match'
    when 3
      'api_good_match'
    when 4
      'local_others_match'
    when 5
      'api_others_match'
    else
      'undefined'
    end
  end
end
