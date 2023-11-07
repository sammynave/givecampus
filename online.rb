# frozen_string_literal: true
class Online
  def initialize(rows:)
    @rows = rows
  end

  def by_designation
    designations = {}
    @rows.each do |row|
      row_designations = JSON.parse(row['designation'])
      donor = row['email'].downcase
      row_designations.each do |(designation_name, amount)|
        if designations[designation_name]
          designations[designation_name][:amount] += amount.to_f
          designations[designation_name][:donations] += 1
          designations[designation_name][:donors].add(donor)
        else
          designations[designation_name] = {
            amount: amount.to_f,
            donations: 1,
            donors: Set.new([donor])
          }
        end
      end
    end
    designations
  end

  def by_affiliation
    affiliations = {}
    @rows.each do |row|
      amount = row['amount'].to_f
      donor = row['email'].downcase
      row_affiliations = JSON.parse(row['affiliation'])
      row_affiliations.keys.each do |affiliation|
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
    end
    affiliations
  end
end
