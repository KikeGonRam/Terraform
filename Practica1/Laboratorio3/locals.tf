locals {
  # Sufijo común: <organización>-<proyecto>-<carga>-<ambiente>-<región>-<instancia>
  suffix   = "utvt-integradora-web-qa-mxc-001"
  location = "mexicocentral"

  tags = {
    project     = "integradora"
    environment = "qa"
    owner       = "utvt"
    managed_by  = "terraform"
  }
}
