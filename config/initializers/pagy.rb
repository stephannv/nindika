# frozen_string_literal: true

require 'pagy'
require 'pagy/extras/bootstrap'
require 'pagy/extras/i18n'

Pagy::DEFAULT[:link_extra] = 'class="btn font-weight-bold"'
Pagy::DEFAULT[:size] = [0, 0, 0, 0]
