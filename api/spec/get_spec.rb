describe "GET" do

    context "Quando é um usuário registrado" do

        let(:user) { build(:registered_user) }
        let(:token) { ApiUser.token(user.email, user.password)}
        let(:resultado) { ApiUser.find(token, user.id) }
        let(:user_data) { Database.new.find_user(user.email) }

        it { expect(resultado.response.code).to eql "200" }
        it { expect(resultado.parsed_response["full_name"]).to eql user_data["full_name"] }
        it { expect(resultado.parsed_response["password"]).to eql user_data["password"] }
        it { expect(resultado.parsed_response["email"]).to eql user_data["email"] }        
        it { expect(Time.parse(resultado.parsed_response["createdAt"])).to eql Time.parse(user_data["created_at"]) }
        it { expect(Time.parse(resultado.parsed_response["updatedAt"])).to eql Time.parse(user_data["updated_at"]) }
    end

    context "Quando não encontrado" do
        let(:user) { build(:registered_user) }
        let(:token) { ApiUser.token(user.email, user.password)}
        let(:resultado) { ApiUser.find(token, "0") }

        it { expect(resultado.response.code).to eql "404" }
        
    end

    context "Quando o ID é inválido" do
        let(:user) { build(:registered_user) }
        let(:token) { ApiUser.token(user.email, user.password)}
        let(:resultado) { ApiUser.find(token, "abc123") }

        it { expect(resultado.response.code).to eql "412" }
    end

    context "Quando o ID é de outro usuário" do
        let(:user) { build(:registered_user) }
        let(:other_user) { build(:registered_user) }
        let(:token) { ApiUser.token(user.email, user.password)}
        let(:resultado) { ApiUser.find(token, other_user.id) }

        it { expect(resultado.response.code).to eql "401" }
    end

end