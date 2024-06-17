
// Entry point for the build script in your package.json
import Rails from '@rails/ujs'

import 'bootstrap'
import 'masonry-layout'

// JQuery is imported in the main layout just for these
import '@nathanvda/cocoon'
// I can't make this work, so it's included in the layout for now
// import '@selectize/selectize/dist/js/standalone/selectize.js'

import 'src/preview'
import 'src/bulk_edit'
import 'src/model_edit'
import 'src/tag'
import 'src/carousel'
import 'src/file_size_validation'

// Load i18n definitions
import { I18n } from 'i18n-js'
import locales from './locales.json'

Rails.start()

window.i18n = new I18n(locales)
