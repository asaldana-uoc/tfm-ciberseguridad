# Aplicar el formato y el estilo predefinido a los archivos de terraform
cd terraform
echo "Aplicando formato y estilo a los archivos terraform"
echo "---------------------------------------------------"
terraform fmt -recursive
echo "\n"

# Generar información de los módulos de terraform en formato Markdown
echo "Generando la documentación de los módulos de terraform"
echo "------------------------------------------------------"
find . -maxdepth 1 -mindepth 1 -type d | while read dir; do
 cd "$dir"
 terraform-docs markdown table --output-file README.md --output-mode inject .
 cd ..
done

