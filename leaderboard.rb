require 'csv'
require 'json'
require_relative 'offline.rb'
require_relative 'online.rb'

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
