Rails.application.config.session_store :cookie_store,
                                       key: '_evaluacion_session',
                                       path: '/evaluacion',
                                       same_site: :lax