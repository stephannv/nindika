# frozen_string_literal: true

require 'pagy'
require 'pagy/extras/bootstrap'
require 'pagy/extras/i18n'

Pagy::VARS[:link_extra] = 'class="btn btn-dark btn-lg fw-bold"'
Pagy::VARS[:size] = [0, 0, 0, 0]
