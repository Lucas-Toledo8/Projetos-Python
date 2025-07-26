@echo off
setlocal

rem -- Menu principal --
echo Qual operacao voce deseja realizar?
echo [1] Fazer merge (Master - Main)
echo [2] Fazer push normal
echo [3] Iniciar novo repositorio
set /p opcao_principal="Escolha uma opcao (1, 2 ou 3): "

if "%opcao_principal%"=="1" goto merge_main
if "%opcao_principal%"=="2" goto push_normal
if "%opcao_principal%"=="3" goto init_repo

echo.
echo Opcao invalida. Encerrando o script.
pause
goto fim

:merge_main
echo.
echo === Realizando Merge (Master - Main) ===
set /p confirmacao="Pronto para mesclar o Master na Main? (s/n): "
if /i not "%confirmacao%"=="s" goto fim

echo Buscando informacoes de branches remotas...
git fetch
if %errorlevel% neq 0 goto erro_fetch

echo Trocando para a branch 'main'...
git checkout main
if %errorlevel% neq 0 goto erro_checkout

echo Mesclando a branch 'master' na 'main'...
git merge --allow-unrelated-histories master
if %errorlevel% neq 0 goto erro_merge

echo Enviando as alteracoes mescladas para o GitHub...
call git push origin main --verbose
if %errorlevel% neq 0 goto erro_push

echo.
echo Merge concluido com sucesso! O conteudo da Master agora esta na Main.
goto fim

:push_normal
echo.
echo === Realizando Push Normal ===
set /p commit_msg="Digite a mensagem do commit: "

echo.
git add . ":(exclude)git-push.bat"
git commit -m "%commit_msg%"

echo.
rem -- Submenu de branches --
echo Para qual branch voce deseja enviar?
echo [1] Master
echo [2] Main
echo [3] Ambos
set /p opcao_push="Escolha uma opcao (1, 2, 3): "

if "%opcao_push%"=="1" goto push_master
if "%opcao_push%"=="2" goto push_main
if "%opcao_push%"=="3" goto push_ambos

echo.
echo Opcao invalida. As alteracoes foram salvas localmente.
pause
goto fim

:push_master
echo.
echo Enviando para a branch Master...
call git push origin master --verbose
goto verificar_erro

:push_main
echo.
echo Enviando para a branch Main...
call git push origin main --verbose
goto verificar_erro

:push_ambos
echo.
echo Enviando para Master e Main...
call git push origin master --verbose
call git push origin main --verbose
goto verificar_erro

:init_repo
echo.
echo === Iniciando Novo Repositorio ===
echo Inicializando o repositorio Git local...
git init
if %errorlevel% neq 0 goto erro_init

set /p remote_url="Cole o URL do seu novo repositorio (ex: https://github.com/usuario/projeto.git): "

echo.
echo Configurando o endereco remoto...
git remote add origin %remote_url%
if %errorlevel% neq 0 goto erro_add_remote

echo.
echo Adicionando e fazendo o commit dos arquivos...
git add . ":(exclude)git-push.bat"
git commit -m "Commit inicial do repositorio"
if %errorlevel% neq 0 goto erro_commit

echo.
echo Fazendo o primeiro push...
call git push -u origin master --verbose
if %errorlevel% neq 0 goto erro_push

echo.
echo Repositorio iniciado e configurado com sucesso!
goto fim

:verificar_erro
if %errorlevel% neq 0 (
    echo.
    echo ERRO: A operacao falhou! Verifique as mensagens acima.
) else (
    echo.
    echo Operacao concluida com sucesso!
)

goto fim

:erro_checkout
echo.
echo ERRO: Nao foi possivel trocar para a branch 'main'.
goto fim

:erro_merge
echo.
echo ERRO: Nao foi possivel mesclar a branch 'master'. Pode haver conflitos.
goto fim

:erro_push
echo.
echo ERRO: Nao foi possivel enviar as alteracoes.
goto fim

:erro_add_remote
echo.
echo ERRO: Nao foi possivel adicionar o endereco remoto. Verifique o URL.
goto fim

:erro_commit
echo.
echo ERRO: Nao foi possivel criar o commit.
goto fim

:erro_init
echo.
echo ERRO: Nao foi possivel inicializar o repositorio Git.
goto fim

:erro_fetch
echo.
echo ERRO: Nao foi possivel buscar as branches remotas. Verifique a conexao ou o endereco remoto.
goto fim

:fim
pause
endlocal