import { Body, Controller, Get, HttpCode, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser, CurrentUser, Public } from '../common/decorators';
import { AuthService } from './auth.service';
import { LoginDto, RegisterDto } from './dto/auth.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private auth: AuthService) {}

  @Public()
  @Post('login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Login (Flutter e Next.js). Retorna { token, accessToken, user }' })
  login(@Body() dto: LoginDto) { return this.auth.login(dto); }

  @Public()
  @Post('register')
  @ApiOperation({ summary: 'Cadastro (usado pelo Flutter). Cria usuário com perfil VISUALIZADOR' })
  register(@Body() dto: RegisterDto) { return this.auth.register(dto); }

  @ApiBearerAuth()
  @Post('logout')
  @HttpCode(200)
  @ApiOperation({ summary: 'Invalida o token atual' })
  logout(@CurrentUser() user: AuthUser) { return this.auth.logout(user); }

  @ApiBearerAuth()
  @Get('me')
  @ApiOperation({ summary: 'Usuário autenticado' })
  me(@CurrentUser() user: AuthUser) { return this.auth.me(user.id); }
}
