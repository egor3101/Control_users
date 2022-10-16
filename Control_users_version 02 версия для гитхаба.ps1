#Меняю глобальные переменные для EXE



#РАСКОММЕНТИТЬ ПРИ КОМПЕЛЕ В ЕХЕ!!!!!!!
#Не выводить подтвержение 
#$ConfirmPreference = "None"
# Не выводить ошибки
#$ErrorActionPreference = 'SilentlyContinue'



Write-Host "Введитие ФИО пользователя"-ForegroundColor Black -BackgroundColor White
$user_login= Read-Host 

#Считаем количиство пользователей с таким ФИО
$number_users=((Get-ADUser -Filter "(Name -like'$user_login*')"  |  Select-Object SamAccountName).SamAccountName).Count

#Если количиство пользователей с данным ФИО болешь 1
if ($number_users -gt 1){

    $list_same_user=@((Get-ADUser -Filter "(Name -like'$user_login*')"  |  Select-Object SamAccountName).SamAccountName)

   #Выводим пронумерованный список
    For($i = 0; $i -lt $list_same_user.Count; $i++)
{
    "{0}.{1}{2}{3}" -f (1+$i), $list_same_user[$i].GivenName, $list_same_user[$i].SN, $list_same_user[$i]
}   

    Write-Host "Введите номер нужного пользователя"-ForegroundColor Black -BackgroundColor White
    $answer_number_user=Read-Host 
    $user_login=$list_same_user[$answer_number_user-1] #Выбираем нужного пользователя из списка
    $variable_for_move_OU= Get-ADUser -Identity $user_login
}


#Если пользователь с таким ФИО один, то присваеваем переменной его логин
else{
    
    $user_login=(Get-ADUser -Filter "(Name -like'$user_login*')"  |  Select-Object SamAccountName).SamAccountName
    $variable_for_move_OU= Get-ADUser -Identity $user_login
    Write-Host "Пользователь с таким ФИО успешно найден!`n"-ForegroundColor Black -BackgroundColor White

}

Write-Host "Введите ФИО Руководителя пользователя"-ForegroundColor Black -BackgroundColor White
$fio_boss= Read-Host 

#Считаем количиство руководителей с таким ФИО
$number_boss=((Get-ADUser -Filter "(Name -like'$fio_boss*')"  |  Select-Object SamAccountName).SamAccountName).Count

#Если количиство руководителей с данным ФИО болешь 1
if ($number_boss -gt 1){

    $list_same_boss=@((Get-ADUser -Filter "(Name -like'$fio_boss*')"  |  Select-Object SamAccountName).SamAccountName)

   #Выводим пронумерованный список
    For($i = 0; $i -lt $list_same_boss.Count; $i++)
{
    "{0}.{1}{2}{3}" -f (1+$i), $list_same_boss[$i].GivenName, $list_same_boss[$i].SN, $list_same_boss[$i]
}   
    #Выбираем нужного руководителя из выведенного списка
    Write-Host "Введите номер нужного руководителя"-ForegroundColor Black -BackgroundColor White
    $answer_number_boss=Read-Host 
    $fio_boss=$list_same_boss[$answer_number_boss-1] #Присваиваем переменной выбранного руководителя
          
}


#Если руководитель с таким ФИО один, то присваеваем переменной его логин
else{

    $fio_boss=(Get-ADUser -Filter "(Name -like'$fio_boss*')"  |  Select-Object SamAccountName).SamAccountName
    Write-Host "Руководитель с таким ФИО успешно найден!`n"-ForegroundColor Black -BackgroundColor White

}




Write-Host "Какой это вид пользователя?"-ForegroundColor Black -BackgroundColor White
Write-Host "1-Обычный`n2-Без ПК"

#Чтбы занчение было либо 1 либо 2
While ($true){


    $answer_what_user = Read-Host

    if (($answer_what_user -eq 1) -or ($answer_what_user -eq 2)){

        break 

    }

    else {
    
        Write-Host "Неверное значение`nВведите 1 или 2"-ForegroundColor Black -BackgroundColor White
    
    }


}


Write-Host "Что будем делать?"-ForegroundColor Black -BackgroundColor White
Write-Host "1-Восстановить УЗ`n2-Новый сотрудник"

$answer_what= Read-Host 

Write-Host "Какой ДЦ?"-ForegroundColor Black -BackgroundColor White
Write-Host "1-Вешки-Праймари`n2-Север" 
$answer_dc= Read-Host 


#Логика для выбора OU

Write-Host "Выберите OU, в которую необходимо переместить сотрудника"-ForegroundColor Black -BackgroundColor White
Write-Host "1-Pelican-Altufievo"
$answer_what_DC= Read-Host

if ($answer_what_DC -eq 1){

    #Логика для выбора конкретно отдела в OU Pelican-Altufievo
    Write-Host "Какая OU?"-ForegroundColor Black -BackgroundColor White
    Write-Host "1-AnotherUsers`n2-Disribgroups`n3-NewUsers`n4-OU-Accounts`n5-OU-HR`n6-OU-Insurance`n7-OU-IT`n8-Outsource`n9-OU-Sales`n10-OU-Service`n11-OU-Store`n12-OU-Support`n13-OU-TopMan`n14-OU-VWServer`n15-Public Objects`n16-SecurityGroups`n17-Service Accounts"
    $answer_what_department = Read-Host




    if ($answer_what_department -eq 1){
    
        $answer_what_end_OU=8
    
    }
    elseif ($answer_what_department -eq 2){
    
        $answer_what_end_OU=9
        
    }
     elseif ($answer_what_department -eq 3){
    
        $answer_what_end_OU=10
    
    }
     elseif ($answer_what_department -eq 4){
    
        $answer_what_end_OU=11
    
    }
     elseif ($answer_what_department -eq 5){
    
        $answer_what_end_OU=12
    
    }
     elseif ($answer_what_department -eq 6){
    
        $answer_what_end_OU=13
    
    }
     elseif ($answer_what_department -eq 7){
    
        $answer_what_end_OU=14
    
    }
     elseif ($answer_what_department -eq 8){
    
        $answer_what_end_OU=15
    
    }



    #OU-Sales OU-Sales создавала первым поэтому у неё нет ещё одной вспомогательной переменной, как у других подобных OU 
    elseif ($answer_what_department -eq 9){
        Write-Host "Какая конкретно OU?"-ForegroundColor Black -BackgroundColor White
        Write-Host "1-Просто OU-Sales`n2-OU-Sales-BMW`n3-OU-Sales-BMW-Moto`n4-OU-Sales-YAK`n5-OU-Sales-Nissan`n6-OU-Sales-Renault`n7-OU-Sales-Skoda"
        $answer_what_end_OU= Read-Host
    
    }
    #END OU-Sales




    #OU-Service
     elseif ($answer_what_department -eq 10){
        Write-Host "Какая конкретно OU?"-ForegroundColor Black -BackgroundColor White
        Write-Host "1-Просто OU-Service`n2-OU-Masters`n3-OU-Mechanics`n4-OU-Service-Skoda`n5-OU-Service-BMW`n6-OU-Service-Nissan`n7-OU-Service-Office`n8-OU-Service-Renault"
        $answer_OU_Servic = Read-Host
        if ($answer_OU_Servic -eq 1){
        
            $answer_what_end_OU = 16
        }
        elseif ($answer_OU_Servic -eq 2){
        
            $answer_what_end_OU = 17
        }
        elseif ($answer_OU_Servic -eq 3){
        
            $answer_what_end_OU = 18
        }
        elseif ($answer_OU_Servic -eq 4){
        
            $answer_what_end_OU = 19
        }
        elseif ($answer_OU_Servic -eq 5){
        
            $answer_what_end_OU = 20
        }
        elseif ($answer_OU_Servic -eq 6){
        
            $answer_what_end_OU = 21
        }
        elseif ($answer_OU_Servic -eq 7){
        
            $answer_what_end_OU = 22
        }
        elseif ($answer_OU_Servic -eq 8){
        
            $answer_what_end_OU = 23
        }
    #END OU-Service




    } 
    elseif ($answer_what_department -eq 11){
    
            $answer_what_end_OU = 24
    
    } 
    elseif ($answer_what_department -eq 12){
    
            $answer_what_end_OU = 25
    
    } 
    elseif ($answer_what_department -eq 13){
    
            $answer_what_end_OU = 26
    
    } 



    #OU-VWServer
    elseif ($answer_what_department -eq 14){
        Write-Host "Какая конкретно OU?"-ForegroundColor Black -BackgroundColor White
        Write-Host "1-Просто VWSever`n2-OU-Insurance`n3-OU-Sale`n4-OU-Service`n5-OU-Store`n6-TopManagers"
        $answer_OU_VWSever= Read-Host
        if ($answer_OU_VWSever -eq 1){
        
            $answer_what_end_OU = 27
        
        }
        elseif ($answer_OU_VWSever -eq 2){
        
            $answer_what_end_OU = 28
        
        }
        elseif ($answer_OU_VWSever -eq 3){
        
            $answer_what_end_OU = 29
        
        }
        elseif ($answer_OU_VWSever -eq 4){
        
            $answer_what_end_OU = 30
        
        }
        elseif ($answer_OU_VWSever -eq 5){
        
            $answer_what_end_OU = 31
        
        }
        elseif ($answer_OU_VWSever -eq 6){
        
            $answer_what_end_OU = 32
        
        }
   #End OU-VWServer




    } 
    elseif ($answer_what_department -eq 15){
    
        $answer_what_end_OU = 33
    
    } 
    elseif ($answer_what_department -eq 16){
    
        $answer_what_end_OU = 34
    
    } 
    elseif ($answer_what_department -eq 17){
    
        $answer_what_end_OU = 35
    
    }
    

}



#Логика для Восстановления УЗ
if($answer_what -eq "1"){


    #Проверяем в каки рассылках есть пользователь
    $list_groups = @(Get-ADPrincipalGroupMembership $user_login | select name).name
    $group_domain = "Domain Users"
    $answer_check_domain_group = $null -ne ($list_groups | ? { $group_domain -match $_ })

    Write-Host "Введите табельный номер пользователя"-ForegroundColor Black -BackgroundColor White
    $personnel_number=Read-Host  

    #Добавляем юзера в Domain Users, если его там нет
    if ($answer_check_domain_group -eq $false){

        #Добавляем юзера в Domain Users
        Add-ADGroupMember -ErrorAction SilentlyContinue -Identity "Domain Users" -Members $user_login 
    
        #Задаём Domain Users по умолчанию
        $NewPrimaryGroupToken = (Get-ADGroup "Domain Users" -Properties primaryGroupToken).primaryGroupToken
        Set-ADUser -Identity $user_login -Replace @{primaryGroupID=$NewPrimaryGroupToken}

        #Удаляем из Disabled_users
        Remove-ADGroupMember -Identity Disabled_users -Members $user_login 

    }

    #Включаем учётную запись
    Enable-ADAccount -Identity $user_login 

    #Разблокируем учётную запись
    Unlock-ADAccount –Identity $user_login 

    #Заставляем сменить пароль при следующем входе в УЗ
    Set-ADUser -Identity $user_login -ChangePasswordAtLogon $true 

    #Меняем руководителя
    Set-ADUser -Identity $user_login -Manager $fio_boss 


     
}



#Логика для Новый сотрудник
if($answer_what -eq "2"){



    #Меняем руководителя
    Set-ADUser -Identity $user_login -Manager $fio_boss

}



#Добавляем в универсальные рассылки

#Праймари
if($answer_dc -eq 1){
 
    Add-ADGroupMember -Identity "#Все сотрудники Пеликан_Вешки_Праймари" -Members $user_login

}
#Север
if($answer_dc -eq 2){
 
    Add-ADGroupMember -Identity "#Все сотрудники ОП Север" -Members $user_login

}




#Перемещаем в нужную OU

#Для OU-Sales.....
if ($answer_what_end_OU -eq 1){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sales,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"     
}

elseif ($answer_what_end_OU -eq 2){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sales-BMW,OU=OU-Sales,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}

elseif ($answer_what_end_OU -eq 3){        
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sales-BMW-Moto,OU=OU-Sales,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}

elseif ($answer_what_end_OU -eq 4){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sales-BMW-YAK,OU=OU-Sales,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 5){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sales-Nissan,OU=OU-Sales,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"        
}

elseif ($answer_what_end_OU -eq 6){        
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sales-Renault,OU=OU-Sales,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}

elseif ($answer_what_end_OU -eq 7){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sales-Skoda,OU=OU-Sales,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}





#AnotherUsers
elseif ($answer_what_end_OU -eq 8){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=AnotherUsers,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#Distribgroups
elseif ($answer_what_end_OU -eq 9){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=Distribgroups,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#NewUsers
elseif ($answer_what_end_OU -eq 10){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=NewUsers,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#OU-Accounting
elseif ($answer_what_end_OU -eq 11){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Accounts,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#OU-HR
elseif ($answer_what_end_OU -eq 12){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-HR,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#ou_Insurance
elseif ($answer_what_end_OU -eq 13){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Insurance,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#OU-IT
elseif ($answer_what_end_OU -eq 14){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-IT,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#OU-Outsource
elseif ($answer_what_end_OU -eq 15){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Outsource,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}



#OU-Service
elseif ($answer_what_end_OU -eq 16){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 17){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Masters,OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 18){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Mechanics,OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 19){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Service- Skoda,OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 20){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Service-BMW,OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 21){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Service-Nissan,OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 22){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Service-Office,OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 23){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Service-Renault,OU=OU-Service,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#END OU-Service



#OU-Store
elseif ($answer_what_end_OU -eq 24){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Store,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#OU-Support
elseif ($answer_what_end_OU -eq 25){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Support,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#OU-TopMan
elseif ($answer_what_end_OU -eq 26){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-TopMan,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}


#OU-VWServer
elseif ($answer_what_end_OU -eq 27){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-VWSever,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 28){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Insurance,OU=OU-VWSever,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 29){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Sale,OU=OU-VWSever,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 30){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Service,OU=OU-VWSever,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 31){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-Store,OU=OU-VWSever,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
elseif ($answer_what_end_OU -eq 32){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=OU-TopManagers,OU=OU-VWSever,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#End OU-VWServer



#Public objects
elseif ($answer_what_end_OU -eq 33){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=Public objects,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#SecurityGroups
elseif ($answer_what_end_OU -eq 34){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=SecurityGroups,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}
#Service Accounts
elseif ($answer_what_end_OU -eq 35){
    Move-ADObject -Identity $variable_for_move_OU -TargetPath "OU=Service Accounts,OU=OU-Pelikan-Altufievo,OU=OU-Moscow,DC=int,DC=rolfcorp,DC=ru"
}

#Сделано для удобности в EXE файле
Write-Host "Скрипт выполнен успешно!"-ForegroundColor Black -BackgroundColor White

Start-Sleep -Seconds 2