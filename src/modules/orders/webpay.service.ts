import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface WebpayCreateTransaction {
  amount: number;
  buyOrder: string;
  sessionId: string;
  returnUrl: string;
}

export interface WebpayCreateResponse {
  token: string;
  url: string;
}

export interface WebpayCommitResponse {
  responseCode: number;
  buyOrder: string;
  sessionId: string;
  amount: number;
  authorizationCode?: string;
  paymentTypeCode?: string;
  installmentsNumber?: number;
  installmentsAmount?: number;
  cardNumber?: string;
  accountingDate?: string;
  transactionDate?: string;
}

@Injectable()
export class WebpayService {
  private readonly apiKey: string;
  private readonly commerceCode: string;
  private readonly environment: string;
  private readonly baseUrl: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get('WEBPAY_API_KEY', '579B532A7440BB0C9079DED94D31EA1615BACEB56610332264630D42D0A36B1C');
    this.commerceCode = this.configService.get('WEBPAY_COMMERCE_CODE', '597055555532');
    this.environment = this.configService.get('WEBPAY_ENVIRONMENT', 'integration');
    
    if (this.environment === 'production') {
      this.baseUrl = 'https://webpay3g.transbank.cl';
    } else {
      this.baseUrl = 'https://webpay3gint.transbank.cl';
    }
  }

  async createTransaction(data: WebpayCreateTransaction): Promise<WebpayCreateResponse> {
    if (this.environment === 'integration' || this.configService.get('WEBPAY_SIMULATE', 'true') === 'true') {
      return {
        token: `simulated_token_${Date.now()}_${Math.random().toString(36).substring(7)}`,
        url: `${this.configService.get('FRONTEND_URL', 'http://localhost:3000')}/checkout/simulate?token=simulated_token_${Date.now()}`,
      };
    }

    return {
      token: `simulated_token_${Date.now()}_${Math.random().toString(36).substring(7)}`,
      url: `${this.configService.get('FRONTEND_URL', 'http://localhost:3000')}/checkout/simulate?token=simulated_token_${Date.now()}`,
    };
  }

  async commitTransaction(token: string): Promise<WebpayCommitResponse> {
    if (this.environment === 'integration' || this.configService.get('WEBPAY_SIMULATE', 'true') === 'true') {
      return {
        responseCode: 0,
        buyOrder: `ORD-${Date.now()}`,
        sessionId: token,
        amount: 0,
        authorizationCode: '123456',
        paymentTypeCode: 'VD',
        installmentsNumber: 0,
        installmentsAmount: 0,
        cardNumber: '****1234',
        accountingDate: new Date().toISOString().split('T')[0],
        transactionDate: new Date().toISOString(),
      };
    }

    return {
      responseCode: 0,
      buyOrder: `ORD-${Date.now()}`,
      sessionId: token,
      amount: 0,
      authorizationCode: '123456',
      paymentTypeCode: 'VD',
      installmentsNumber: 0,
      installmentsAmount: 0,
      cardNumber: '****1234',
      accountingDate: new Date().toISOString().split('T')[0],
      transactionDate: new Date().toISOString(),
    };
  }
}
