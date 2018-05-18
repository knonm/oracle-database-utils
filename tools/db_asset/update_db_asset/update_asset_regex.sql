ACCEPT pcDir PROMPT 'File directory: '
ACCEPT pcArq PROMPT 'File name: '

CREATE OR REPLACE DIRECTORY ASSET_DIR AS '&pcDir';

DECLARE

  vcDelim  CONSTANT VARCHAR2(1) := ';';

  vtFile   utl_file.file_type;
  vcLine   VARCHAR2(32767);
  vtInv    schema1.tb_asset%ROWTYPE;

BEGIN

  vtFile := utl_file.fopen(location     => 'ASSET_DIR',
                           filename     => '&pcArq',
                           open_mode    => 'r',
                           max_linesize => 32767);

  LOOP

    utl_file.get_line(file   => vtFile,
                      buffer => vcLine,
                      len    => NULL);

    vtInv.INSTANCE_NAME    := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 1));
    vtInv.HOSTNAME         := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 2));
    vtInv.VIP_HOST         := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 3));
    vtInv.PSU              := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 5));
    vtInv.ENVIRONMENT_TYPE := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 6));
    vtInv.INSTANCE_STATUS  := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 10));
    vtInv.DISABLED_IN      := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 11));
    vtInv.COMMENTS         := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 12));
    vtInv.LAST_MODIFIED    := UPPER(REGEXP_SUBSTR(vcLine, '[^' || vcDelim || ']+', 1, 13));

    BEGIN

      INSERT INTO schema1.tb_asset
      VALUES vtInv;

    EXCEPTION

      WHEN DUP_VAL_ON_INDEX THEN

        UPDATE schema1.tb_asset
        SET    ROW = vtInv
        WHERE  UPPER(instancia) = vtInv.INSTANCE_NAME
        AND    UPPER(hostname) = vtInv.HOSTNAME;

    END;

    COMMIT;

  END LOOP;

  utl_file.fclose(file => vtFile);

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    utl_file.fclose(file => vtFile);

END;
/
