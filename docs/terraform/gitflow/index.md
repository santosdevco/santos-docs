# Git Flow para los repos de Terraform
Git flow es una metodología de trabajo que facilita la integración de cambios de equipos grandes de desarrollo, basada en el división de las distintas etapas de producción de software en distintas ramas del repositorio:
 
 
![Git Flow](../../img/gitflow1.svg)
<!-- ![Git Flow](../../../img/git_flow_explanation.svg) -->
 
* **Master:** En la rama máster se encuentran las releases estables de nuestro software. Esta es la rama que un usuario típico se descarga para usar nuestro software, por lo que todo lo que hay en esta rama debería ser funcional. Sin embargo, puede que las últimas mejoras introducidas en el software no estén disponibles todavía en esta rama.
* **Develop:** En esta rama surge de la última release de máster. En ella se van integrando todas las nuevas características hasta la siguiente release.
* **Feature-X:** Cada nueva mejora o característica que vayamos a introducir en nuestro software tendrá una rama que contendrá su desarrollo. Las ramas de feature salen de la rama develop y una vez completado el desarrollo de la mejora, se vuelven a integrar en el develop.
* **Release-X:** Las ramas de release se crean cuando se va a publicar la siguiente versión del software y surgen de la rama develop . En estas ramas, el desarrollo de nuevas características se congela, y se trabaja en arreglar bugs y generar documentación. Una vez listo para la publicación, se integra en máster y se etiqueta con el número de versión correspondiente. Se integran también con develop, ya que su contenido ha podido cambiar debido a nuevas mejoras.
* **Hotfix-X:** Si nuestro código contiene bugs críticos que es necesario parchear de manera inmediata, es posible crear una rama hotfix a partir de la publicación correspondiente en la rama master. Esta rama contendrá únicamente los cambios que haya que realizar para parchear el bug. Una vez arreglado, se integrará en master, con su etiqueta de versión correspondiente y en develop.
 
## Flujo de trabajo
En este momento nosotros hacemos uso  de un esquema reducido de esta metodología teniendo solamente de  las ramas de características, y ramas primarias. A continuación  hacemos una explicación corta de cómo aplicar la metodología.
### Nota
*Se hace una documentación por cada repositorio para hacerlo más sencillo.*
 