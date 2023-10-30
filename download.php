<?php

    if (!function_exists("str_starts_with")) {
        function str_starts_with($haystack, $needle) {
            return substr_compare($haystack, $needle, 0, strlen($needle)) === 0;
        }
    }
    if (!function_exists("str_ends_with")) {
        function str_ends_with($haystack, $needle) {
            return substr_compare($haystack, $needle, -strlen($needle)) === 0;
        }
    }

    $request = $_SERVER["QUERY_STRING"];

    if (
        !isset($_SERVER["REDIRECT_STATUS"]) ||
        $_SERVER["REDIRECT_STATUS"] !== "200"
    ) {
        die("405");
    }

    if ($request === "") {
        die("400");
    }

    if (preg_match("/(^|\/)..\//", $request)) {
        die("403");
    }

    $file = dirname($_SERVER["SCRIPT_FILENAME"]) . "/" . $request;

    $filepath = dirname($file);
    $filename = basename($file);

    $countername = $filename . ".DOWNLOADS";
    $counter     = $filepath . "/" . $countername;

    $redirectname = $filename . ".REDIRECT";
    $redirect     = $filepath . "/" . $redirectname;

    if (!file_exists($file)) {
        die("404");
    }

    if (is_dir($file)) {
        die("406");
    }

    if (
        str_ends_with($file, ".DOWNLOADS") ||
        str_ends_with($file, ".REDIRECT")
    ) {
        readfile($file);
        exit;
    }

    $fp = fopen("$counter", "c+");
    flock($fp, LOCK_EX);
    $count = intval(trim(fgets($fp))) + 1;
    fseek($fp, 0);
    ftruncate($fp, 0);
    fwrite($fp, "$count" . "\n");
    fflush($fp);
    flock($fp, LOCK_UN);
    fclose($fp);

    if (file_exists($redirect)) {
        $fp = fopen("$redirect", "r");
        $url = trim(fgets($fp));
        fclose($fp);
        header("Location: " . $url, true, 307);
        exit;
    }

    header("Content-Length: " . filesize($file));
    header("Content-Type: " . mime_content_type($file));
    header("Content-Transfer-Encoding: binary");
    header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
    header("Cache-Control: post-check=0, pre-check=0", false);
    header("Pragma: no-cache");

    if (in_array("mod_xsendfile", apache_get_modules())) {
        header("X-SendFile: $file");
        exit;
    }

    if (ob_get_level()) {
        ob_end_clean();
    }
    readfile($file);
    exit;

?>