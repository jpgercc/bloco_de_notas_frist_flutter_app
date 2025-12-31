# Flutter


<details>
    <summary>Flutter Layout <a href='https://youtu.be/KP_Ysqu6JOY?si=XU-rFBhuW9Z4RNJk'>Aula #03</a></summary>
    
    A primeira coisa que precisamos fornecer para interfacie é a base, uma página em branco, chamada:

    'Scaffold', só depois podemos adicionar outros elementos da nossa escolha como por ex 

    'AppBar' (usado para navegar em multiplas telas do app),

    'Container' que ajem como divs e 

    'Column' que define uma posição horizontal, onde dentro dela podemos colocar widgets que obviamente desejamos que fique nessa posição. Alternativamente temos o

    'Row' para vertical

    Row pode conter columns e visse versa

<a href='https://docs.flutter.dev/ui/layout'>Mais informações sobre o layout do Flutter</a>

</details>


<details>
    <summary>Pré-requisitos <a href='https://youtu.be/MTBZdERVsOU?list=PLqdwHeoSjEN-9aGd-RxaS_2cyD_AKT0c_'>Aula #05</a></summary>
<a href='https://youtu.be/7zA96C_q-6E?list=PLqdwHeoSjEN-9aGd-RxaS_2cyD_AKT0c_'>Other tutorial (better)</a>

- Android Studio (para poder emular)
- Flutter (Flutter SDK inclui o dart, instalado na pasta C:/src/flutter)
- Flutter and android config emulator

<a href='https://docs.flutter.dev/ui/layout'>Mais informações sobre o layout do Flutter</a>

</details>

<details>
    <summary>Imagens e pubspec.yaml Aula #08 e 9</summary>
<a href='https://youtu.be/7zA96C_q-6E?list=PLqdwHeoSjEN-9aGd-RxaS_2cyD_AKT0c_'>Other tutorial (better)</a>

Para incluir link de imagens usamos NetworkImage, ex.: image: NetworkImage('urlaqui',),

Para incluir imagens encontradas em pastas, primeiro o prof. criou a pasta imagens na raiz
    depois ele edicou o arquivo de dependencias 'pubspec.yaml' para incluir a pasta imagens, da seguinte forma:
          assets:
        - imagens/godel.jpg
*MUITO CUIDADO COM OS EPAÇOS NO 'pubspec.yaml', espaços definem seções e subseções*
Por fim clicamos em pubget para rodar o comando no terminal para baixar as novas dependencias

Se tivermos muitos arquivos, inves de declarar imagem por imagem no .yaml podemos simplismente declarar a pasta:
    assets:
    - imagens/


</details>

<details>
    <sumarry>Icone</sumarry>
    https://youtu.be/6Jo3r34B8Y0?list=PLqdwHeoSjEN-9aGd-RxaS_2cyD_AKT0c_
    
Para fazer um icone, deixa a imagem em tamanho padrao para ico: https://www.appicon.co/
\android\app\src\main\res
substitua os arquivos pelos baixados do site, confira se adicionou todos os icones, sao muitos

</details>

eu tinha feito algo eu mesmo mas perdi agora ta a bosta da calculadora da IA, e, fica aqui minha nota de repudio a documentação do flutter vao tomar no cu flutters vcs fizeram um blog enorme eu só quero saber qual enigma tenho q digitar pra fazer os bgl pqp pelo amor de deus cara, eles ensinam bem ate mas oq importa nao se acha vtnc documentador do flutter, vai virar jornalista sla cara pqp RESUME RESUME MUITO ESSA EH MINHA NOTA >:C vou continuar usando pq eh oq tem ne q outra alternativa a flutter existe? #luto mas pelo menos dart é #muitolegal :D


