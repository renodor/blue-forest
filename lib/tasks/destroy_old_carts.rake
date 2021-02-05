desc 'Destroy old carts'
task destroy_old_carts: :environment do
  Rails.logger.info('Destroy old carts daily task started')

  old_carts = Cart.where('created_at < ?', DateTime.current - 48.hours)
  Rails.logger.info("#{old_carts.length} old carts found")

  destroyed_carts = old_carts.destroy_all
  Rails.logger.info("#{destroyed_carts.length} old carts destroyed")

  Rails.logger.info('Destroy old carts daily task finished')
end
