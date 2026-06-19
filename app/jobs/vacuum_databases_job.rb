# Compacts the SQLite databases so freed pages are returned to disk.
#
# Solid Queue, Cache and Cable each prune their own rows (finished jobs,
# expired cache entries, old messages), and CleanupSamplesJob trims samples,
# but SQLite never shrinks a database file on its own — only VACUUM rewrites
# it at its actual size. Without this the queue database in particular grows
# unbounded and eventually fills the disk.
class VacuumDatabasesJob < ApplicationJob

  # VACUUM is per-database; each Solid gem connects to its own SQLite file.
  CONNECTION_CLASSES = [
    ActiveRecord::Base, # primary (monitors, samples)
    SolidQueue::Record, # queue
    SolidCache::Record, # cache
    SolidCable::Record, # cable
  ].freeze

  def perform
    CONNECTION_CLASSES.each do |klass|
      klass.with_connection do |connection|
        connection.execute("VACUUM")
        Rails.logger.info("[VacuumDatabasesJob] Vacuumed #{connection.pool.db_config.database}")
      end
    end
  end

end
