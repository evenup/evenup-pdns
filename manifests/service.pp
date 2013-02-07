# TODO - document me
class pdns::service {

  service { 'pdns':
    ensure  => running,
    enable  => true,
  }

  service { 'pdns-recursor':
    ensure  => running,
    enable  => true,
  }

}