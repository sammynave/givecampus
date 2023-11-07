require 'csv'
require 'json'

class Offline
  def initialize(rows:)
    @rows = rows
  end

  def by_affiliation
    affiliations = {}
    @rows.each do |row|
      affiliation = row['affiliation']
      amount = row['amount'].to_f
      next if affiliation.nil? || affiliation.size == 0 ||

      if affiliations[affiliation]
        affiliations[affiliation][:amount] += amount
        affiliations[affiliation][:donors] += 1
      else
        affiliations[affiliation] = {
          amount: amount,
          donors: 1
        }
      end

    end
    affiliations
  end

  def by_designation
    designations = {}
    @rows.each do |row|
      designation_name = row['designation_name']
      amount = row['designated_amount'].to_f
      next if designation_name.nil? || designation_name.size == 0

      if designations[designation_name]
        designations[designation_name][:amount] += amount
        designations[designation_name][:donors] += 1
      else
        designations[designation_name] = {
          amount: amount,
          donors: 1
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
      row_designations.each do |(designation_name, amount)|
        if designations[designation_name]
          designations[designation_name][:amount] += amount.to_f
          designations[designation_name][:donors] += 1
        else
          designations[designation_name] = {
            amount: amount.to_f,
            donors: 1
          }
        end
      end
    end
    designations
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
    offline_designations.merge(online_designations) do |key, old, new|
      {
        amount: old[:amount] + new[:amount],
        donors: old[:donors] + new[:donors]
      }
    end
  end

  def offline_affiliations
    @offline.by_affiliation
  end

  def offline_designations
    @offline.by_designation
  end

  def online_designations
    @online.by_designation
  end
end
