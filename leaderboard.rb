require 'csv'
require 'json'

class Leaderboard

  def initialize(offline_csv_path:, online_csv_path:)
    @offline_rows = CSV.open('offline-donors.csv', headers: true)
    @online_rows = CSV.open('online-donors.csv', headers: true)
  end

  def by_designation
    offline_designations.merge(online_designations) do |key, old, new|
      {
        amount: old[:amount] + new[:amount],
        donors: old[:donors] + new[:donors]
      }
    end
  end

  def offline_designations
    designations = {}
    @offline_rows.each do |row|
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

  def online_designations
    designations = {}
    @online_rows.each do |row|
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
