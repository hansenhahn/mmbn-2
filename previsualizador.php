<?php
if (isset($_POST['submit'])) {
    var_dump('submittou');
}

$script = file_get_contents('Scripts/descricoes_chips.tpl');
?>

<!DOCTYPE html>
<html data-bs-theme="dark">

<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-aFq/bzH65dt+w6FI2ooMVUpc+21e0SRygnTpmBvdBgSdnuTN7QbdgL+OapgHtvPp" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/codemirror.min.css" integrity="sha512-uf06llspW44/LZpHzHT6qBOIVODjWtv4MxCricRxkzvopAlSWnTf6hpZTFxuuZcuNE9CBQhqE0Seu1CoRk84nQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/theme/abcdef.min.css" integrity="sha512-Gzm0Fa7gFAThiSK+XOmw4e5Iou/zUMNPgyHcx+RemJUS8KeusL4DlvTM2qfP+A5mfeDexq5uOjFBz29VJP+EMA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="previsualizador_css.css" rel="stylesheet" />
</head>

<body>
    <nav class="navbar bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                Previsualizador de Descrições de Chips do MMBN2
            </a>
        </div>
    </nav>

    <form method="post" action="previsualizador.php">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm">
                    <div class="mb-3">
                        <label for="descricoes" class="form-label">Descrições:</label>
                        <textarea class="form-control" id="descricoes"><?php echo $script ?></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" name="submit">Salvar</button>
                </div>
                <div class="col-sm">
                    <div class="mb-3">
                        <label for="previa" class="form-label">Prévia:</label>
                        <div id="previa">
                            <span class="descricao"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/js/bootstrap.bundle.min.js" integrity="sha384-qKXV1j0HvMUeCBQ+QVp7JcfGl760yU08IQ+GpUo5hlbpg51QRiuqHAJz8+BrxE/N" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/codemirror.min.js" integrity="sha512-05P5yOM5/yfeUDgnwTL0yEVQa0Cg6j3alVSbWSQtBxz24fERIyW3jeBdp7ZSHcgPMRYJWoa26IIWhJ2/UComLA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/mode/python/python.min.js" integrity="sha512-Vs2GKxnxnTQBRW7o2xXZ9A28njjmu5RToS42efiKNEWmikov0inZY522EtGVK5CcVo0M/FQwmXsTfl9skgRnvw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="previsualizador_js.js"></script>
</body>

</html>