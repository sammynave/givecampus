require 'csv'
require 'json'

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

class Leaderboard
  def initialize(offline_csv_path:, online_csv_path:)
    offline_rows = CSV.open('offline-donors.csv', headers: true)
    @offline = Offline.new(rows: offline_rows)

    online_rows = CSV.open('online-donors.csv', headers: true)
    @online = Online.new(rows: online_rows)
  end

  def by_designation
    result = @offline.by_designation.merge(@online.by_designation) do |key, old, new|
      {
        amount: old[:amount] + new[:amount],
        donations: old[:donations] + new[:donations],
        donors: old[:donors].merge(new[:donors])
      }
    end

    convert_donor_counts(result)
  end

  def by_affiliation
    result = @offline.by_affiliation.merge(@online.by_affiliation) do |key, old, new|
      {
        amount: old[:amount] + new[:amount],
        donations: old[:donations] + new[:donations],
        donors: old[:donors].merge(new[:donors])
      }
    end
    convert_donor_counts(result)
  end

  def offline_affiliations
    convert_donor_counts(@offline.by_affiliation)
  end

  def online_affiliations
    convert_donor_counts(@online.by_affiliation)
  end

  def offline_designations
    convert_donor_counts(@offline.by_designation)
  end

  def online_designations
    convert_donor_counts(@online.by_designation)
  end

  private

  def convert_donor_counts(h)
    mapped = h.map do |key, value|
      value[:donors] = value[:donors].size
      [key, value]
    end
    Hash[mapped]
  end
end
