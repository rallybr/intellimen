-- =====================================================
-- SCHEMA DO BANCO DE DADOS INTELLIMEN
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- TABELAS PRINCIPAIS
-- =====================================================

-- Tabela de usuários
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    whatsapp VARCHAR(20),
    photo_url TEXT,
    birth_date DATE,
    state VARCHAR(50),
    access_level VARCHAR(20) DEFAULT 'general' CHECK (access_level IN ('general', 'member', 'campus', 'academy')),
    has_completed_profile BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    partner_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de desafios
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    week_number INTEGER NOT NULL CHECK (week_number >= 1 AND week_number <= 53),
    category VARCHAR(100) NOT NULL,
    difficulty INTEGER NOT NULL CHECK (difficulty >= 1 AND difficulty <= 5),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de desafios dos usuários
CREATE TABLE user_challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    partner_id UUID REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'failed')),
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, challenge_id)
);

-- Tabela de quizzes
CREATE TABLE quizzes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('partner', 'individual')),
    category VARCHAR(100) NOT NULL,
    difficulty INTEGER NOT NULL CHECK (difficulty >= 1 AND difficulty <= 5),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de perguntas dos quizzes
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quiz_id UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    options JSONB NOT NULL, -- Array de strings
    correct_answer INTEGER NOT NULL,
    explanation TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de quizzes dos usuários
CREATE TABLE user_quizzes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    quiz_id UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    partner_id UUID REFERENCES users(id),
    score INTEGER DEFAULT 0,
    total_questions INTEGER NOT NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'abandoned')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de solicitações de parceria
CREATE TABLE partnership_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    requested_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(requester_id, requested_id)
);

-- Tabela de solicitações de acesso (Campus/Academy)
CREATE TABLE access_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    requested_access VARCHAR(20) NOT NULL CHECK (requested_access IN ('campus', 'academy')),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    reason TEXT,
    admin_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de posts do feed
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    image_url TEXT,
    challenge_id UUID REFERENCES challenges(id),
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de curtidas dos posts
CREATE TABLE post_likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(post_id, user_id)
);

-- Tabela de comentários dos posts
CREATE TABLE post_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de notificações
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    related_id UUID, -- ID relacionado (post, challenge, etc.)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_access_level ON users(access_level);
CREATE INDEX idx_users_partner_id ON users(partner_id);
CREATE INDEX idx_user_challenges_user_id ON user_challenges(user_id);
CREATE INDEX idx_user_challenges_challenge_id ON user_challenges(challenge_id);
CREATE INDEX idx_user_challenges_status ON user_challenges(status);
CREATE INDEX idx_user_quizzes_user_id ON user_quizzes(user_id);
CREATE INDEX idx_user_quizzes_quiz_id ON user_quizzes(quiz_id);
CREATE INDEX idx_partnership_requests_requester_id ON partnership_requests(requester_id);
CREATE INDEX idx_partnership_requests_requested_id ON partnership_requests(requested_id);
CREATE INDEX idx_access_requests_user_id ON access_requests(user_id);
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_post_likes_post_id ON post_likes(post_id);
CREATE INDEX idx_post_comments_post_id ON post_comments(post_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- =====================================================
-- FUNÇÕES E TRIGGERS
-- =====================================================

-- Função para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_challenges_updated_at BEFORE UPDATE ON user_challenges
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_partnership_requests_updated_at BEFORE UPDATE ON partnership_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_access_requests_updated_at BEFORE UPDATE ON access_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON posts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_post_comments_updated_at BEFORE UPDATE ON post_comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- POLÍTICAS RLS (Row Level Security)
-- =====================================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE partnership_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLÍTICAS PARA USERS
-- =====================================================

-- Usuários podem ver todos os usuários ativos
CREATE POLICY "Users can view all active users" ON users
    FOR SELECT USING (is_active = true);

-- Usuários podem atualizar apenas seus próprios dados
CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

-- Usuários podem inserir apenas seus próprios dados
CREATE POLICY "Users can insert own profile" ON users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- =====================================================
-- POLÍTICAS PARA CHALLENGES
-- =====================================================

-- Todos podem ver desafios ativos
CREATE POLICY "Anyone can view active challenges" ON challenges
    FOR SELECT USING (is_active = true);

-- =====================================================
-- POLÍTICAS PARA USER_CHALLENGES
-- =====================================================

-- Usuários podem ver seus próprios desafios
CREATE POLICY "Users can view own challenges" ON user_challenges
    FOR SELECT USING (auth.uid() = user_id OR auth.uid() = partner_id);

-- Usuários podem inserir seus próprios desafios
CREATE POLICY "Users can insert own challenges" ON user_challenges
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seus próprios desafios
CREATE POLICY "Users can update own challenges" ON user_challenges
    FOR UPDATE USING (auth.uid() = user_id);

-- =====================================================
-- POLÍTICAS PARA QUIZZES
-- =====================================================

-- Todos podem ver quizzes ativos
CREATE POLICY "Anyone can view active quizzes" ON quizzes
    FOR SELECT USING (is_active = true);

-- =====================================================
-- POLÍTICAS PARA QUIZ_QUESTIONS
-- =====================================================

-- Todos podem ver perguntas de quizzes ativos
CREATE POLICY "Anyone can view quiz questions" ON quiz_questions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM quizzes 
            WHERE quizzes.id = quiz_questions.quiz_id 
            AND quizzes.is_active = true
        )
    );

-- =====================================================
-- POLÍTICAS PARA USER_QUIZZES
-- =====================================================

-- Usuários podem ver seus próprios quizzes
CREATE POLICY "Users can view own quizzes" ON user_quizzes
    FOR SELECT USING (auth.uid() = user_id OR auth.uid() = partner_id);

-- Usuários podem inserir seus próprios quizzes
CREATE POLICY "Users can insert own quizzes" ON user_quizzes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seus próprios quizzes
CREATE POLICY "Users can update own quizzes" ON user_quizzes
    FOR UPDATE USING (auth.uid() = user_id);

-- =====================================================
-- POLÍTICAS PARA PARTNERSHIP_REQUESTS
-- =====================================================

-- Usuários podem ver solicitações que enviaram ou receberam
CREATE POLICY "Users can view partnership requests" ON partnership_requests
    FOR SELECT USING (auth.uid() = requester_id OR auth.uid() = requested_id);

-- Usuários podem inserir solicitações
CREATE POLICY "Users can insert partnership requests" ON partnership_requests
    FOR INSERT WITH CHECK (auth.uid() = requester_id);

-- Usuários podem atualizar solicitações que receberam
CREATE POLICY "Users can update received partnership requests" ON partnership_requests
    FOR UPDATE USING (auth.uid() = requested_id);

-- =====================================================
-- POLÍTICAS PARA ACCESS_REQUESTS
-- =====================================================

-- Usuários podem ver suas próprias solicitações
CREATE POLICY "Users can view own access requests" ON access_requests
    FOR SELECT USING (auth.uid() = user_id);

-- Usuários podem inserir suas próprias solicitações
CREATE POLICY "Users can insert own access requests" ON access_requests
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- POLÍTICAS PARA POSTS
-- =====================================================

-- Usuários podem ver posts públicos
CREATE POLICY "Users can view public posts" ON posts
    FOR SELECT USING (is_public = true);

-- Usuários podem ver seus próprios posts
CREATE POLICY "Users can view own posts" ON posts
    FOR SELECT USING (auth.uid() = user_id);

-- Usuários podem inserir seus próprios posts
CREATE POLICY "Users can insert own posts" ON posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seus próprios posts
CREATE POLICY "Users can update own posts" ON posts
    FOR UPDATE USING (auth.uid() = user_id);

-- Usuários podem deletar seus próprios posts
CREATE POLICY "Users can delete own posts" ON posts
    FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLÍTICAS PARA POST_LIKES
-- =====================================================

-- Usuários podem ver curtidas de posts públicos
CREATE POLICY "Users can view post likes" ON post_likes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM posts 
            WHERE posts.id = post_likes.post_id 
            AND posts.is_public = true
        )
    );

-- Usuários podem inserir curtidas
CREATE POLICY "Users can insert post likes" ON post_likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Usuários podem deletar suas próprias curtidas
CREATE POLICY "Users can delete own post likes" ON post_likes
    FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLÍTICAS PARA POST_COMMENTS
-- =====================================================

-- Usuários podem ver comentários de posts públicos
CREATE POLICY "Users can view post comments" ON post_comments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM posts 
            WHERE posts.id = post_comments.post_id 
            AND posts.is_public = true
        )
    );

-- Usuários podem inserir comentários
CREATE POLICY "Users can insert post comments" ON post_comments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seus próprios comentários
CREATE POLICY "Users can update own post comments" ON post_comments
    FOR UPDATE USING (auth.uid() = user_id);

-- Usuários podem deletar seus próprios comentários
CREATE POLICY "Users can delete own post comments" ON post_comments
    FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- POLÍTICAS PARA NOTIFICATIONS
-- =====================================================

-- Usuários podem ver suas próprias notificações
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

-- Usuários podem atualizar suas próprias notificações
CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- =====================================================
-- FUNÇÕES AUXILIARES
-- =====================================================

-- Função para verificar se usuário tem parceiro
CREATE OR REPLACE FUNCTION has_partner(user_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users 
        WHERE id = user_uuid 
        AND partner_id IS NOT NULL
    );
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se usuário pode enviar solicitação de parceria
CREATE OR REPLACE FUNCTION can_send_partnership_request(requester_uuid UUID, requested_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
    -- Verificar se o usuário solicitado já tem parceiro
    IF has_partner(requested_uuid) THEN
        RETURN FALSE;
    END IF;
    
    -- Verificar se já existe uma solicitação pendente
    IF EXISTS (
        SELECT 1 FROM partnership_requests 
        WHERE requester_id = requester_uuid 
        AND requested_id = requested_uuid 
        AND status = 'pending'
    ) THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Função para calcular idade
CREATE OR REPLACE FUNCTION calculate_age(birth_date DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(birth_date));
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DADOS INICIAIS (OPCIONAL)
-- =====================================================

-- Inserir alguns desafios de exemplo
INSERT INTO challenges (title, description, week_number, category, difficulty) VALUES
('Despertar Cedo', 'Acorde às 6h da manhã por uma semana completa', 1, 'Disciplina', 2),
('Exercício Diário', 'Faça 30 minutos de exercício todos os dias', 2, 'Saúde', 3),
('Leitura Diária', 'Leia 20 páginas de um livro por dia', 3, 'Conhecimento', 2),
('Meditação', 'Medite por 10 minutos todas as manhãs', 4, 'Bem-estar', 1),
('Organização', 'Mantenha seu quarto organizado por uma semana', 5, 'Disciplina', 2);

-- Inserir alguns quizzes de exemplo
INSERT INTO quizzes (title, description, type, category, difficulty) VALUES
('Quiz de Disciplina', 'Teste seus conhecimentos sobre disciplina pessoal', 'individual', 'Disciplina', 2),
('Quiz de Saúde', 'Avalie seu conhecimento sobre saúde e bem-estar', 'individual', 'Saúde', 3),
('Quiz de Parceria - Semana 1', 'Quiz sobre os desafios da primeira semana', 'partner', 'Geral', 2);

-- Inserir perguntas para o primeiro quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation) VALUES
(
    (SELECT id FROM quizzes WHERE title = 'Quiz de Disciplina' LIMIT 1),
    'Qual é o benefício de acordar cedo?',
    '["Mais tempo para atividades", "Menos produtividade", "Mais sono", "Menos energia"]',
    0,
    'Acordar cedo proporciona mais tempo para realizar atividades e ser mais produtivo.'
),
(
    (SELECT id FROM quizzes WHERE title = 'Quiz de Disciplina' LIMIT 1),
    'Quantos minutos de exercício são recomendados por dia?',
    '["15 minutos", "30 minutos", "60 minutos", "120 minutos"]',
    1,
    '30 minutos de exercício diário são suficientes para manter a saúde.'
); 