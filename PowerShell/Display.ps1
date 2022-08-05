class AbstractDisplay {

    AbstractDisplay() {
        $type = $this.GetType()
        if ($type -eq [AbstractDisplay]) {
            throw("$type は 継承して利用してください")
        }
    }
    #抽象メソッド1 -> サブクラスに実装を任せる抽象メソッド
    hidden [void] open() {
        throw("オーバーライドしてください。")
    }

    #抽象メソッド2 -> サブクラスに実装を任せる抽象メソッド
    hidden [void] print() {
        throw("オーバーライドしてください。")
    }

    #抽象メソッド3 -> サブクラスに実装を任せる抽象メソッド
    hidden [void] close() {
        throw("オーバーライドしてください。")
    }

    #ここで実装する
    [void] display() {
        $this.open()
        for ($i = 0; $i -lt 5; $i++) {
            $this.print()
        }
        $this.close()
    }
}

#AbstructDisplayに対して実装をした具体クラス
class CharDisplay:AbstractDisplay {
    [char] $ch

    CharDisplay([char] $ch) {
        $this.ch = $ch
    }

    hidden [void] open() {
        Write-Host -NoNewline "<<"
    }

    hidden [void] print() {
        Write-Host -NoNewline $this.ch
    }

    hidden [void] close() {
        Write-Host ">>"
    }
}

#AbstructDisplayに対して実装をした具体クラス
class StringDisplay:AbstractDisplay {
    [string] $string
    [int] $width

    hidden StringDisplay([String] $string) {
        $this.string = $string
        $this.width = [System.Text.Encoding]::GetEncoding("shift_jis").GetByteCount($string)
    }

    hidden [void] open() {
        $this.printLine()
    }

    hidden [void] print() {
        $decolatedLine =  "|" + $this.string + "|"
        Write-Host $decolatedLine
    }

    hidden [void] close() {
        $this.printLine()
    }

    hidden [void] printLine() {
        Write-Host -NoNewline "+"

        for ($i = 0; $i -lt $this.width; $i++) {
            Write-Host -NoNewline "-"
        }

        Write-Host "+"
    }
}

#AbstructDisplayに対して不完全な実装をした具体クラス -> 実行時throw
class IncompleteDisplay:AbstractDisplay {
    [string] $string
    [int] $width

    IncompleteDisplay([String] $string) {
        $this.string = $string
        $this.width = [System.Text.Encoding]::GetEncoding("shift_jis").GetByteCount($string)
    }

    hidden [void] open() {
        $this.printLine()
    }

    hidden [void] print() {
        $decolatedLine =  "|" + $this.string + "|"
        Write-Host $decolatedLine
    }

    hidden [void] printLine() {
        Write-Host -NoNewline "+"

        for ($i = 0; $i -lt $this.width; $i++) {
            Write-Host -NoNewline "-"
        }

        Write-Host "+"
    }
}

#cli
$ErrorActionPreference = 'Continue'
[AbstractDisplay]$foo = [CharDisplay]::new([char]'H')
$foo.display()

[AbstractDisplay]$bar = [StringDisplay]::new('Hello World!')
$bar.display()

[AbstractDisplay]$piyo = [StringDisplay]::new('こんにちは！')
$piyo.display()

[AbstractDisplay]$bad = [IncompleteDisplay]::new('Hello!')

try {
    $bad.display() #Errorになる
}
catch {
    Write-Host $Error[0]
    Pause
}

[AbstractDisplay[]]$store = @(
    [CharDisplay]::new([char]'H'),
    [StringDisplay]::new('Hello World!'),
    [StringDisplay]::new('こんにちは！')
)
foreach ($item in $store) {
    $item.display()
}
