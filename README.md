# IntelliMen

Aplicativo multiplataforma para desafios e desenvolvimento pessoal, focado em transformar homens através de desafios semanais e parcerias.

## 🚀 Funcionalidades

### **Sistema de Desafios**
- 53 desafios semanais cuidadosamente elaborados
- Acompanhamento de progresso individual e em parceria
- Sistema de avaliação e notas para cada desafio

### **Sistema de Quiz**
- Quizzes individuais para consolidar aprendizado
- Quizzes em parceria para reforçar conhecimento
- Sistema de pontuação e ranking

### **Níveis de Acesso**
1. **Geral**: Acesso ao manifesto e cadastro básico
2. **Membro**: Acesso completo aos desafios e quizzes
3. **Campus**: Exclusivo para jovens entre 17-25 anos
4. **Academy**: Conteúdo premium para membros selecionados

### **Sistema de Parcerias**
- Envio de solicitações de parceria
- Aprovação/rejeição de solicitações
- Desafios em conjunto com parceiros

### **Feed Social**
- Compartilhamento de conquistas
- Sistema de curtidas e comentários
- Feed estilo Instagram

## 🎨 Identidade Visual

**Cores Principais:**
- **Preto**: `#1E1E1E`
- **Grafite**: `#2F2F2F`
- **Branco**: `#FFFFFF`
- **Azul**: `#007AFF`
- **Ouro/Laranja**: `#FF9500`

## 🛠️ Tecnologias

- **Frontend**: Flutter 3.29.3
- **Backend**: Supabase
- **Autenticação**: Supabase Auth
- **Banco de Dados**: PostgreSQL
- **Storage**: Supabase Storage

## 📱 Estrutura do Projeto

```
lib/
├── core/
│   ├── config/          # Configurações do Supabase
│   ├── constants/       # Constantes do app
│   ├── services/        # Serviços (Supabase, etc.)
│   └── utils/           # Utilitários
├── features/
│   ├── auth/           # Autenticação
│   ├── challenges/     # Sistema de desafios
│   ├── quiz/          # Sistema de quizzes
│   ├── profile/       # Perfil do usuário
│   ├── feed/          # Feed social
│   ├── dashboard/     # Dashboard principal
│   ├── campus/        # Funcionalidades do Campus
│   └── academy/       # Funcionalidades da Academy
└── shared/
    ├── models/         # Modelos de dados
    ├── widgets/        # Widgets reutilizáveis
    └── providers/      # Providers do Riverpod
```

## 🗄️ Banco de Dados

### **Tabelas Principais:**
- `users` - Usuários e perfis
- `challenges` - Desafios disponíveis
- `user_challenges` - Desafios dos usuários
- `quizzes` - Quizzes disponíveis
- `quiz_questions` - Perguntas dos quizzes
- `user_quizzes` - Quizzes dos usuários
- `partnership_requests` - Solicitações de parceria
- `access_requests` - Solicitações de acesso
- `posts` - Posts do feed
- `notifications` - Notificações

### **Políticas de Segurança:**
- Row Level Security (RLS) habilitado
- Políticas específicas para cada tabela
- Controle de acesso baseado em roles

## 🚀 Instalação

### **Pré-requisitos:**
- Flutter SDK 3.7.2+
- Dart SDK
- Android Studio / VS Code
- Conta no Supabase

### **Passos:**

1. **Clone o repositório:**
```bash
git clone <repository-url>
cd intellimen
```

2. **Instale as dependências:**
```bash
flutter pub get
```

3. **Configure o Supabase:**
   - Crie um projeto no [Supabase](https://supabase.com)
   - Execute o script SQL em `database_schema.sql`
   - Configure as variáveis de ambiente

4. **Configure as credenciais:**
   - Atualize `lib/core/config/supabase_config.dart` com suas credenciais

5. **Execute o aplicativo:**
```bash
flutter run
```

## 📋 Configuração do Supabase

### **1. Criar Projeto:**
- Acesse [supabase.com](https://supabase.com)
- Crie um novo projeto
- Anote a URL e chave anônima

### **2. Executar Schema:**
- Vá para SQL Editor no Supabase
- Execute o conteúdo de `database_schema.sql`

### **3. Configurar Storage:**
- Crie buckets para imagens de perfil e posts
- Configure as políticas de acesso

### **4. Configurar Auth:**
- Configure as opções de autenticação
- Defina as políticas de senha

## 🔧 Desenvolvimento

### **Estrutura de Features:**
Cada feature segue a estrutura:
```
feature/
├── presentation/
│   ├── pages/
│   └── widgets/
├── domain/
│   ├── entities/
│   └── repositories/
└── data/
    ├── models/
    └── repositories/
```

### **State Management:**
- **Riverpod** para gerenciamento de estado
- **Provider** para injeção de dependências

### **Navegação:**
- **GoRouter** para navegação entre telas
- Navegação baseada em rotas nomeadas

## 📱 Telas Principais

### **1. Splash Screen**
- Logo animado
- Verificação de autenticação
- Redirecionamento automático

### **2. Welcome/Manifesto**
- Apresentação do projeto
- 5 páginas explicativas
- Botões de ação

### **3. Autenticação**
- Login com email/senha
- Cadastro em duas etapas
- Validação de dados

### **4. Home (3 Abas)**
- **Academy**: Conteúdo premium
- **IntelliMen**: Dashboard principal
- **Campus**: Exclusivo para jovens

### **5. Dashboard**
- Progresso dos desafios
- Lista de desafios ativos
- Estatísticas

### **6. Feed**
- Posts dos usuários
- Sistema de curtidas
- Comentários

### **7. Perfil**
- Informações do usuário
- Estatísticas
- Menu de opções

## 🔒 Segurança

### **Autenticação:**
- Supabase Auth
- JWT tokens
- Refresh automático

### **Autorização:**
- Row Level Security
- Políticas por tabela
- Controle de acesso por nível

### **Dados:**
- Criptografia em trânsito
- Validação de entrada
- Sanitização de dados

## 🧪 Testes

### **Executar testes:**
```bash
flutter test
```

### **Cobertura:**
```bash
flutter test --coverage
```

## 📦 Build

### **Android:**
```bash
flutter build apk --release
```

### **iOS:**
```bash
flutter build ios --release
```

### **Web:**
```bash
flutter build web --release
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 📞 Suporte

Para suporte, entre em contato:
- Email: suporte@intellimen.com
- WhatsApp: (11) 99999-9999

---

**IntelliMen** - Transformando homens através de desafios 💪
