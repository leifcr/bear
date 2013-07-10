Delayed::Worker.backend = :active_record
Delayed::Worker.max_attempts = 1
Delayed::Worker.destroy_failed_jobs = false
# Delayed::Worker.read_ahead = 1 # just read 1 job at a time