В gitignore terraform мы игнорируем следующие файлы:
# Скрытая дирректория .terraform
**/.terraform/*

# Файлы с расширением .tfstate и .tfstate.* (например example.tfstate.test)
*.tfstate
*.tfstate.*

# Конкретный файл
crash.log

# Файлы с расширением .tfvars
*.tfvars

# Файл override.tf и override.tf.json, а так же файлы, имена которых заканчиваются на _override.tf и _override.tf.json (например example_override.tf.json)
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Исключение из вышеуказанного правила
# !example_override.tf

# Файлы, имена которых содержат символы "tfplan" (например example_tfplan_)
# example: *tfplan*

# Игнорирование конкретных файлов
.terraformrc
terraform.rc

