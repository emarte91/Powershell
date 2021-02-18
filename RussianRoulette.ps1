Write-Host "Welcome to Russian Roulette`n6 Chambers 1 Bullet`nTest your luck" -ForegroundColor Yellow
$Counter = 1

While(1 -eq 1){
    $Pull = Read-Host "Pull the trigger? Y/N:"
    $Spin = Get-Random -Minimum 1 -Maximum 6
    if($Spin -eq 2){
        Write-Host "You died" -ForegroundColor Red
        $Counter = 1
        $Retry = Read-Host "Play Again? Y/N:"
        if($Retry -eq "Y"){
            $Pull
        }
        else{
            Write-Host "Thanks for playing!" -ForegroundColor Green
            break
        }
    }
    else{
        Write-Host "Still Alive!" -ForegroundColor Green
        Write-Host "You have survived $Counter times!"
        $Counter += 1
        $Pull
        
    }
}
