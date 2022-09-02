import { application } from "controllers/application"

import ItemThumbnailsController from "controllers/item_thumbnails_controller.js"
application.register("item-thumbnails", ItemThumbnailsController)

import PriceHistoryChartController from "controllers/price_history_chart_controller.js"
application.register("price-history-chart", PriceHistoryChartController)
