if missing_required_deps:
            logger.error("Faltan dependencias requeridas del sistema")
            logger.error(f"Dependencias faltantes: {', '.join(missing_required_deps)}")
            return

        # Inicialización de Ollama
        try:
            ollama = OllamaIntegration(logger=logger)
            logger.info("Ollama inicializado correctamente")
        except Exception as e:
            logger.error(f"Error iniciando Ollama: {str(e)}")
            ollama = None

        # Tu código aquí

    except Exception as e:
        logger.error(f"Error crítico: {str(e)}")
        raise
EOF
                ;;
            *)
                cat > "$file" << EOF
"""
Componente de AIPATT: ${file##*/}
Este archivo será configurado durante la primera ejecución.
Consulta la documentación en docs/INSTALL.md para más información.
"""
EOF
                ;;
        esac
        echo "✓ Creado nuevo archivo: $file"
    fi
done

# Instalar Ollama
echo "Instalando Ollama..."
if ! command -v ollama &> /dev/null; then
    if ! curl -sSL https://ollama.ai/install.sh | sh; then
        echo "× Error instalando Ollama"
        exit 1
    fi

    if command -v systemctl &> /dev/null; then
        echo "Iniciando servicio Ollama..."
        if ! systemctl start ollama; then
            echo "× Error iniciando servicio Ollama"
            echo "NOTA: Deberás iniciar Ollama manualmente"
        fi
    else
        echo "NOTA: Deberás iniciar Ollama manualmente"
    fi
    echo "✓ Ollama instalado correctamente"
fi

# Establecer permisos correctos
echo "Configurando permisos..."
chmod +x main.py
chmod +x install.sh

echo "✓ Instalación básica completada."
echo "Para iniciar AIPATT, ejecuta: python3 main.py"
