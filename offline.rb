# frozen_string_literal: true
class Offline
  def initialize(rows:)
    @rows = rows
  end

  def by_affiliation
    affiliations = {}
    @rows.each do |row|
      donor = row['email'].downcase
      affiliation = row['affiliation']
      amount = row['amount'].to_f
      next if affiliation.nil? || affiliation.size == 0 ||

      if affiliations[affiliation]
        affiliations[affiliation][:amount] += amount
        affiliations[affiliation][:donations] += 1
        affiliations[affiliation][:donors].add(donor)
      else
        affiliations[affiliation] = {
          amount: amount,
          donations: 1,
          donors: Set.new([donor])
        }
      end

    end
    affiliations
  end

  def by_designation
    designations = {}
    @rows.each do |row|
      donor = row['email'].downcase
      designation_name = row['designation_name']
      amount = row['designated_amount'].to_f
      next if designation_name.nil? || designation_name.size == 0

      if designations[designation_name]
        designations[designation_name][:amount] += amount
        designations[designation_name][:donations] += 1
        designations[designation_name][:donors].add(donor)
      else
        designations[designation_name] = {
          amount: amount,
          donations: 1,
          donors: Set.new([donor])
        }
      end
    end
    designations
  end
end
